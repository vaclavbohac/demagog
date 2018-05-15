import * as React from 'react';
import { Mutation, Query } from 'react-apollo';
import { connect } from 'react-redux';
import { RouteComponentProps } from 'react-router';

import { addFlashMessage } from '../actions/flashMessages';
import Error from './Error';
import Loading from './Loading';

import { SpeakerForm } from './forms/SpeakerForm';

import { UpdateSpeaker } from '../queries/mutations';
import { GetSpeaker } from '../queries/queries';

interface ISpeakerDetailProps extends RouteComponentProps<{ id: string }> {
  id: number;
  addFlashMessage: (message: string) => void;
}

class SpeakerDetail extends React.Component<ISpeakerDetailProps> {
  private onComplete = () => {
    this.props.addFlashMessage('Uložení problěhlo v pořádku');
  };

  private onError = () => {
    this.props.addFlashMessage('Doško k chybě při uložení');
  };

  // tslint:disable-next-line:member-ordering
  public render() {
    const id = parseInt(this.props.match.params.id, 10);

    return (
      <div role="main">
        <h1>Upravit osobu</h1>

        <Query query={GetSpeaker} variables={{ id }}>
          {({ data, loading, error }) => {
            if (loading) {
              return <Loading />;
            }

            if (error) {
              return <Error error={error} />;
            }

            return (
              <Mutation
                mutation={UpdateSpeaker}
                onError={this.onError}
                onCompleted={this.onComplete}
              >
                {(updateSpeaker, { loading }) => (
                  <SpeakerForm
                    speakerQuery={data}
                    onSubmit={(speakerInput) => updateSpeaker({ variables: { id, speakerInput } })}
                    submitting={loading}
                  />
                )}
              </Mutation>
            );
          }}
        </Query>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return {
    addFlashMessage(message: string) {
      dispatch(addFlashMessage(message));
    },
  };
}

export default connect(null, mapDispatchToProps)(SpeakerDetail);
