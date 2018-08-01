/* eslint camelcase: 0 */

import * as React from 'react';

import { Button, Classes, Intent } from '@blueprintjs/core';
import { Form, Formik } from 'formik';
import { DateTime } from 'luxon';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import * as yup from 'yup';

import { GetSourceQuery, SourceInputType } from '../../operation-result-types';
import { IState as ReduxState } from '../../reducers';
import DateField from './controls/DateField';
import MediaPersonalitiesSelect from './controls/MediaPersonalitySelect';
import MediumSelect from './controls/MediumSelect';
import SelectComponentField from './controls/SelectComponentField';
import SpeakersSelect from './controls/SpeakersSelect';
import TextareaField from './controls/TextareaField';
import TextField from './controls/TextField';
import UserSelect from './controls/UserSelect';
import FormGroup from './FormGroup';

interface ISourceFormProps {
  backPath: string;
  source?: GetSourceQuery['source'];
  onSubmit: (formData: SourceInputType) => Promise<any>;
  title: string;

  currentUser: ReduxState['currentUser']['user'];
}

class SourceForm extends React.Component<ISourceFormProps> {
  public render() {
    const { backPath, currentUser, source, title } = this.props;

    const initialValues = {
      name: source ? source.name : '',
      medium_id: source ? source.medium.id : null,
      media_personality_id: source ? source.media_personality.id : null,
      released_at: source ? source.released_at : DateTime.local().toISODate(),
      source_url: source ? source.source_url : '',
      speakers: source ? source.speakers.map((s) => s.id) : [],
      transcript: source && source.transcript ? source.transcript : '',
      expert_id: source && source.expert ? source.expert.id : null,
    };

    // When creating new source, prefill the expert with the current user
    if (!source && currentUser) {
      initialValues.expert_id = currentUser.id;
    }

    return (
      <Formik
        initialValues={initialValues}
        validationSchema={yup.object().shape({
          name: yup.string().required('Je třeba vyplnit název'),
          medium_id: yup.mixed().notOneOf([null], 'Je třeba vybrat pořad'),
          media_personality_id: yup.mixed().notOneOf([null], 'Je třeba vybrat moderátora'),
          released_at: yup.mixed().notOneOf([null], 'Je třeba vyplnit datum publikace'),
          speakers: yup.array().min(1, 'Je třeba vybrat alespoň jednoho řečníka'),
        })}
        onSubmit={(values, { setSubmitting }) => {
          const formData: SourceInputType = {
            ...values,

            // released_at will always be a string, because null won't pass validation
            released_at: values.released_at as string,
          };

          this.props
            .onSubmit(formData)
            .then(() => {
              setSubmitting(false);
            })
            .catch(() => {
              setSubmitting(false);
            });
        }}
      >
        {({ isSubmitting, values }) => (
          <Form>
            <div style={{ float: 'right' }}>
              <Link to={backPath} className={Classes.BUTTON}>
                Zpět
              </Link>
              <Button
                type="submit"
                intent={Intent.PRIMARY}
                style={{ marginLeft: 7 }}
                disabled={isSubmitting}
                text={isSubmitting ? 'Ukládám ...' : 'Uložit'}
              />
            </div>

            <h2>{title}</h2>

            <div style={{ display: 'flex', marginTop: 30 }}>
              <div style={{ flex: '0 0 200px', marginRight: 15 }}>
                <h4>Základní údaje</h4>
              </div>
              <div style={{ flex: '1 1' }}>
                <FormGroup name="name" label="Název">
                  <TextField name="name" />
                </FormGroup>
                <div style={{ display: 'flex' }}>
                  <div style={{ flex: '1 1' }}>
                    <FormGroup name="medium_id" label="Pořad">
                      <SelectComponentField name="medium_id">
                        {(renderProps) => <MediumSelect {...renderProps} />}
                      </SelectComponentField>
                    </FormGroup>
                  </div>
                  <div style={{ flex: '1 1', marginLeft: 15 }}>
                    <FormGroup name="media_personality_id" label="Moderátor">
                      <SelectComponentField name="media_personality_id">
                        {(renderProps) => (
                          <MediaPersonalitiesSelect mediumId={values.medium_id} {...renderProps} />
                        )}
                      </SelectComponentField>
                    </FormGroup>
                  </div>
                </div>
                <FormGroup name="released_at" label="Publikováno">
                  <DateField name="released_at" />
                </FormGroup>
                <FormGroup name="source_url" label="Odkaz" optional>
                  <TextField name="source_url" placeholder="http://www…" />
                </FormGroup>
              </div>
            </div>

            <div style={{ display: 'flex', marginTop: 30 }}>
              <div style={{ flex: '0 0 200px', marginRight: 15 }}>
                <h4>Řečníci</h4>

                <p>Výroky v rámci této diskuze půjde vytvořit jen pro osoby zde vybrané.</p>
              </div>
              <div style={{ flex: '1 1' }}>
                <FormGroup name="speakers" label="Řečníci">
                  <SelectComponentField name="speakers">
                    {(renderProps) => <SpeakersSelect {...renderProps} />}
                  </SelectComponentField>
                </FormGroup>
              </div>
            </div>

            <div style={{ display: 'flex', marginTop: 30 }}>
              <div style={{ flex: '0 0 200px', marginRight: 15 }}>
                <h4>Expert</h4>

                <p>
                  Vybraný expert bude dostávat notifikace při změnách výroků v rámci této diskuze.
                </p>
              </div>
              <div style={{ flex: '1 1' }}>
                <FormGroup name="expert_id" label="Expert" optional>
                  <SelectComponentField name="expert_id">
                    {(renderProps) => <UserSelect roles={['expert', 'admin']} {...renderProps} />}
                  </SelectComponentField>
                </FormGroup>
              </div>
            </div>

            <div style={{ display: 'flex', marginTop: 30 }}>
              <div style={{ flex: '0 0 200px', marginRight: 15 }}>
                <h4>Přepis</h4>

                <p>
                  Je-li dostupný, doporučujeme vyplnit, protože usnaďňuje vytváření výroků
                  označováním v přepisu.
                </p>
              </div>
              <div style={{ flex: '1 1' }}>
                <FormGroup name="transcript" label="Přepis" optional>
                  <TextareaField name="transcript" rows={15} />
                </FormGroup>
              </div>
            </div>
          </Form>
        )}
      </Formik>
    );
  }
}

const mapStateToProps = (state: ReduxState) => ({
  currentUser: state.currentUser.user,
});

const EnhancedSourceForm = connect(mapStateToProps)(SourceForm);

export { EnhancedSourceForm as SourceForm };