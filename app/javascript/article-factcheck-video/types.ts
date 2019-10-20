// FIXME: Should be generated
export interface IArticleStatementsQueryResult {
  article: {
    id: string;
    title: string;
    statements: Array<{
      id: string;
      content: string;
      important: boolean;
      statementVideoMark: {
        start: number;
        stop: number;
      };
      assessment: {
        id: string;
        veracity: {
          id: string;
          key: string;
          name: string;
        };
        shortExplanation: string;
        explanationHtml: string;
      };
      speaker: {
        id: string;
        firstName: string;
        lastName: string;
        avatar: string;
      };
    }>;
  };
}
