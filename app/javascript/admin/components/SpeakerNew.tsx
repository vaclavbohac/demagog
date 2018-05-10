import * as React from 'react';

import { ApolloError } from 'apollo-client';
import { Mutation } from 'react-apollo';
import { connect } from 'react-redux';
import { RouteComponentProps } from 'react-router';
import { withRouter } from 'react-router-dom';
import { addFlashMessage } from '../actions/flashMessages';

import { SpeakerForm } from './forms/SpeakerForm';

import {
  CreateSpeakerMutation,
  CreateSpeakerMutationVariables,
  GetSpeakersQuery,
} from '../operation-result-types';
import { CreateSpeaker } from '../queries/mutations';
import { GetSpeakers } from '../queries/queries';

interface ISpeakerNewProps extends RouteComponentProps<{}> {
  addFlashMessage: (msg: string) => void;
}

class SpeakerNewMutation extends Mutation<CreateSpeakerMutation, CreateSpeakerMutationVariables> {}

class SpeakerNew extends React.Component<ISpeakerNewProps> {
  private onCompleted = () => {
    this.props.addFlashMessage('Osoba byla úspěšně uložena.');
    this.props.history.push('/admin/speakers');
  };

  private onError = (error: ApolloError) => {
    // TODO: Show as an error message
    this.props.addFlashMessage('Při ukládání došlo k chybě.');

    console.error(error); // tslint:disable-line:no-console
  };

  // tslint:disable-next-line:member-ordering
  public render() {
    return (
      <div role="main">
        <h1>Přidat novou osobu</h1>

        <SpeakerNewMutation
          mutation={CreateSpeaker}
          onCompleted={this.onCompleted}
          onError={this.onError}
          update={(cache, { data }) => {
            if (!data) {
              return null;
            }

            const { createSpeaker } = data;

            if (!createSpeaker) {
              return null;
            }

            const speakerWithoutAvatar = {
              ...createSpeaker,
              avatar: null,
            };

            const cacheRecord = cache.readQuery<GetSpeakersQuery>({
              query: GetSpeakers,
              variables: { name: null },
            });
            if (cacheRecord && cacheRecord.speakers) {
              cache.writeQuery({
                data: { speakers: cacheRecord.speakers.concat([speakerWithoutAvatar]) },
                query: GetSpeakers,
                variables: { name: null },
              });
            }
          }}
        >
          {(createSpeaker) => (
            <SpeakerForm
              onSubmit={(speakerInput) => createSpeaker({ variables: { speakerInput } })}
            />
          )}
        </SpeakerNewMutation>
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

export default connect(null, mapDispatchToProps)(withRouter(SpeakerNew));
