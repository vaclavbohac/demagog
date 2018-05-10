import * as React from 'react';

import { Mutation } from 'react-apollo';
import { connect } from 'react-redux';
import { RouteComponentProps } from 'react-router';
import { withRouter } from 'react-router-dom';

import { addFlashMessage } from '../actions/flashMessages';
import {
  createBodyMutation,
  createBodyMutationVariables,
  GetBodiesQuery,
} from '../operation-result-types';
import { CreateBody } from '../queries/mutations';
import { GetBodies } from '../queries/queries';
import { BodyForm } from './forms/BodyForm';

interface IBodyNewProps extends RouteComponentProps<{}> {
  addFlashMessage: (msg: string) => void;
}

class BodyNewMutation extends Mutation<createBodyMutation, createBodyMutationVariables> {}

// tslint:disable-next-line:max-classes-per-file
class BodyNew extends React.Component<IBodyNewProps> {
  public render() {
    return (
      <div role="main">
        <h1>Přidat novou stranu / skupinu</h1>

        <BodyNewMutation
          mutation={CreateBody}
          update={(cache, { data }) => {
            if (!data) {
              return null;
            }

            const { createBody } = data;

            const cacheRecord = cache.readQuery<GetBodiesQuery>({
              query: GetBodies,
              variables: { name: null },
            });
            if (cacheRecord) {
              cache.writeQuery({
                data: { bodies: cacheRecord.bodies.concat([createBody]) },
                query: GetBodies,
                variables: { name: null },
              });
            }
          }}
          onCompleted={this.onCompleted}
          onError={this.onError}
        >
          {(createBody) => (
            <BodyForm onSubmit={(bodyInput) => createBody({ variables: { bodyInput } })} />
          )}
        </BodyNewMutation>
      </div>
    );
  }

  private onCompleted = () => {
    this.props.addFlashMessage('Strana / skupina byla úspěšně uložena.');
    this.props.history.push('/admin/bodies');
  };

  private onError = (error) => {
    // TODO: Show as an error message
    this.props.addFlashMessage('Při ukládání došlo k chybě.');

    console.error(error); // tslint:disable-line:no-console
  };
}

function mapDispatchToProps(dispatch) {
  return {
    addFlashMessage(message: string) {
      dispatch(addFlashMessage(message));
    },
  };
}

export default connect(null, mapDispatchToProps)(withRouter(BodyNew));
