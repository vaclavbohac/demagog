import * as React from 'react';
import { useQuery, useMutation } from 'react-apollo';
import { useParams } from 'react-router-dom';
import {
  GetSource as GetSourceQuery,
  GetSourceVariables as GetSourceQueryVariables,
  CreateStatement as CreateStatementMutation,
  CreateStatementVariables as CreateStatementMutationVariables,
} from '../../operation-result-types';
import { GetSource } from '../../queries/queries';
import { CreateStatement } from '../../queries/mutations';
import { useFlashMessage } from '../../hooks/use-flash-messages';
import { captureException } from '@sentry/browser';
import { StatementNew } from './StatementNew';

export function StatementNewContainer() {
  const addFlashMessage = useFlashMessage();
  const { sourceId } = useParams<{ sourceId: string }>();
  const { data: source, loading, error } = useQuery<GetSourceQuery, GetSourceQueryVariables>(
    GetSource,
    {
      variables: {
        id: parseInt(sourceId, 10),
      },
    },
  );

  useMutation<CreateStatementMutation, CreateStatementMutationVariables>(CreateStatement, {
    onCompleted(sourceId) {
      addFlashMessage('Výrok byl úspěšně přidán.', 'success');
      this.props.history.push(`/admin/sources/${sourceId}`);
    },

    onError(error) {
      addFlashMessage('Při ukládání došlo k chybě.', 'error');
      captureException(error);
    },
  });

  return (
    <StatementNew source={source?.source} loading={loading} error={error} onSubmit={console.log} />
  );
}
