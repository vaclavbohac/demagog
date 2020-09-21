import * as React from 'react';
import Loading from '../Loading';
import { NonIdealState, Classes } from '@blueprintjs/core';
import { Formik, Form } from 'formik';
import { useMemo } from 'react';
import * as yup from 'yup';
import { StatementType } from '../../operation-result-types';
import { Link } from 'react-router-dom';
import classNames from 'classnames';
import TextareaField from '../forms/controls/TextareaField';
import SelectField from '../forms/controls/SelectField';
import FormGroup from '../forms/FormGroup';
import { STATEMENT_TYPES } from '../../constants';
import SelectComponentField from '../forms/controls/SelectComponentField';
import UserSelect from '../forms/controls/UserSelect';

const STATEMENT_TYPE_OPTIONS = Object.keys(STATEMENT_TYPES).map((statementType) => ({
  label: STATEMENT_TYPES[statementType],
  value: statementType,
}));

const validationSchema = yup.object().shape({
  content: yup.string().required('Je třeba vyplnit znění výroku'),
  speaker_id: yup.mixed().notOneOf([null, ''], 'Je třeba vybrat řečníka'),
});

export function StatementNew(props) {
  if (props.loading) {
    return <Loading />;
  }

  if (props.error) {
    return <NonIdealState title="Došlo k chybě při načítání zdroje" />;
  }

  const initialValues = useMemo(
    () => ({
      statement_type: StatementType.factual,
      content: '',
      speaker_id: props.source.speakers?.length ? props.source.speakers[0].id : null,
      evaluator_id: null,
      secondary_evaluators: [],
      note: '',
    }),
    [props.source],
  );

  return (
    <Formik
      initialValues={initialValues}
      validationSchema={validationSchema}
      onSubmit={props.onSubmit}
    >
      {({ isSubmitting }) => {
        return (
          <div style={{ padding: '15px 0 40px 0' }}>
            <Form>
              <div style={{ float: 'right' }}>
                <Link to={`/admin/sources/${props.source.id}`} className={Classes.BUTTON}>
                  Zpět na diskuzi
                </Link>
                <button
                  type="submit"
                  className={classNames(Classes.BUTTON, Classes.INTENT_PRIMARY)}
                  style={{ marginLeft: 7 }}
                  disabled={isSubmitting}
                >
                  {isSubmitting ? 'Ukládám…' : 'Uložit'}
                </button>
              </div>

              <h2 className={Classes.HEADING}>Přidat nový výrok</h2>

              <div style={{ display: 'flex', marginTop: 30 }}>
                <div style={{ flex: '0 0 200px', marginRight: 15 }}>
                  <h4 className={Classes.HEADING}>Výrok</h4>
                </div>
                <div style={{ flex: '1 1' }}>
                  <FormGroup label="Znění" name="content">
                    <TextareaField name="content" placeholder="Vložte či vepište znění…" rows={7} />
                  </FormGroup>
                  <div style={{ display: 'flex' }}>
                    <div style={{ flex: '1 1' }}>
                      <FormGroup label="Řečník" name="speaker_id">
                        <SelectField
                          name="speaker_id"
                          options={
                            props.source.speakers?.map((s) => ({
                              label: `${s.firstName} ${s.lastName}`,
                              value: s.id,
                            })) ?? []
                          }
                        />
                      </FormGroup>
                    </div>
                    <div style={{ flex: '1 1' }}>
                      <FormGroup label="Typ výroku" name="statement_type">
                        <SelectField name="statement_type" options={STATEMENT_TYPE_OPTIONS} />
                      </FormGroup>
                    </div>
                  </div>
                </div>
              </div>

              <div style={{ display: 'flex', marginTop: 30 }}>
                <div style={{ flex: '0 0 200px', marginRight: 15 }}>
                  <h4 className={Classes.HEADING}>Ověřování</h4>
                </div>
                <div style={{ flex: '1 1' }}>
                  <FormGroup label="Ověřovatel" name="evaluator_id" optional>
                    <SelectComponentField name="evaluator_id">
                      {(renderProps) => <UserSelect {...renderProps} />}
                    </SelectComponentField>
                  </FormGroup>
                  <FormGroup label="Vedlejší ověřovatelé" name="secondary_evaluators" optional>
                    <SelectComponentField name="secondary_evaluators">
                      {(renderProps) => <UserSelect {...renderProps} isMulti />}
                    </SelectComponentField>
                  </FormGroup>
                  <FormGroup
                    label="Poznámka pro ověřování"
                    name="note"
                    helperText="Bude přidána jako první komentář v diskuzi k výroku."
                    optional
                  >
                    <TextareaField name="note" rows={4} />
                  </FormGroup>
                </div>
              </div>
            </Form>
          </div>
        );
      }}
    </Formik>
  );
}
