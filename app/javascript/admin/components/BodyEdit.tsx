import * as React from 'react';
import { Mutation, Query } from 'react-apollo';
import { connect } from 'react-redux';
import { RouteComponentProps } from 'react-router';

import { addFlashMessage } from '../actions/flashMessages';
import { UpdateBody } from '../queries/mutations';
import { GetBody } from '../queries/queries';
import Error from './Error';
import { BodyForm } from './forms/BodyForm';
import Loading from './Loading';

interface IBodyDetailProps extends RouteComponentProps<{ id: string }> {
  addFlashMessage: (message: string) => void;
}

function BodyEdit(props: IBodyDetailProps) {
  const id = parseInt(props.match.params.id, 10);

  return (
    <div role="main">
      <h1>Upravit stranu / skupinu</h1>

      <Query query={GetBody} variables={{ id }}>
        {({ data, loading, error }) => {
          if (loading) {
            return <Loading />;
          }

          if (error) {
            return <Error error={error} />;
          }

          return (
            <Mutation
              mutation={UpdateBody}
              onCompleted={() => props.addFlashMessage('Strana / skupina byla úspěšně uložena.')}
            >
              {(updateBody, { loading: submitting }) => (
                <BodyForm
                  bodyQuery={data}
                  onSubmit={(bodyInput) => updateBody({ variables: { id, bodyInput } })}
                  submitting={submitting}
                />
              )}
            </Mutation>
          );
        }}
      </Query>
    </div>
  );
}

function mapDispatchToProps(dispatch) {
  return {
    addFlashMessage(message: string) {
      dispatch(addFlashMessage(message));
    },
  };
}

export default connect(null, mapDispatchToProps)(BodyEdit);
