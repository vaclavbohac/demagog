import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { ApolloProvider } from 'react-apollo';
import { ApolloClient } from 'apollo-client';
import { HttpLink, InMemoryCache } from 'apollo-client-preset';

const cache = new InMemoryCache();
const link = new HttpLink({
  uri: '/graphql',
});

const client = new ApolloClient({ link, cache });

import ArticleFactcheckVideoApp from './ArticleFactcheckVideoApp';

const appRootElement = document.getElementById('article-factcheck-video-app-root');
if (appRootElement !== null) {
  const articleIllustrationImageHtml = appRootElement.innerHTML;

  ReactDOM.render(
    <ApolloProvider client={client}>
      <ArticleFactcheckVideoApp articleIllustrationImageHtml={articleIllustrationImageHtml} />
    </ApolloProvider>,
    appRootElement,
  );
}
