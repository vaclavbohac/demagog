import * as React from 'react';

import styled from '@emotion/styled';
import { execute, makePromise } from 'apollo-link';
import { HttpLink } from 'apollo-link-http';
import { css } from 'emotion';
import gql from 'graphql-tag';
import isHotkey from 'is-hotkey';
import { orderBy } from 'lodash';
import ReactTooltip from 'react-tooltip';
import 'whatwg-fetch';

import demagogLogoIconOnly from './demagog-logo-icon-only.png';
import playIcon from './play-icon.svg';
import { IVideo } from './video/shared';
import YoutubeVideo from './video/YoutubeVideo';

const apolloLink = new HttpLink({ uri: '/graphql', fetch });

const articleStatementsQuery = gql`
  query getArticle($articleId: Int!) {
    article(id: $articleId) {
      id
      title
      statements {
        id
        content
        important
        statementVideoMark {
          start
          stop
        }
        assessment {
          id
          veracity {
            id
            key
            name
          }
          shortExplanation
          explanationHtml
        }
        speaker {
          id
          firstName
          lastName
          avatar
        }
      }
    }
  }
`;

// FIXME: Should be generated
interface IArticleStatementsQueryResult {
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

interface IProps {
  articleIllustrationImageHtml: string;
}

interface IState {
  article: IArticleStatementsQueryResult['article'] | null;
  isPlayerOpen: boolean;
}

class ArticleFactcheckVideoApp extends React.Component<IProps, IState> {
  public state = {
    article: null,
    isPlayerOpen: false,
  };

  public componentDidMount() {
    window.addEventListener('hashchange', this.handleHashChange);
    window.addEventListener('keydown', this.handleKeyDown);

    this.handleHashChange();

    makePromise(
      execute(apolloLink, { query: articleStatementsQuery, variables: { articleId: 774 } }),
    ).then((data) => {
      this.setState({ article: data.data.article });
    });
  }

  public componentWillUnmount() {
    window.removeEventListener('hashchange', this.handleHashChange);
    window.removeEventListener('keydown', this.handleKeyDown);
  }

  public render() {
    const { articleIllustrationImageHtml } = this.props;
    const { article, isPlayerOpen } = this.state;

    return (
      <>
        {isPlayerOpen && article !== null && (
          <Player article={article} onRequestClose={this.closePlayer} />
        )}
        <div
          className={css`
            position: relative;
          `}
        >
          <div
            className={css`
              img {
                display: block;
              }
            `}
            dangerouslySetInnerHTML={{ __html: articleIllustrationImageHtml }}
          ></div>
          {article !== null && (
            <OpenPlayerButton type="button" onClick={this.openPlayer}>
              <OpenPlayerButtonOverlay>
                <OpenPlayerButtonOverlayPlayIcon src={playIcon} alt="Spustit videozáznam" />
                <OpenPlayerButtonOverlayText>
                  Spustit videozáznam propojený s&nbsp;ověřením
                </OpenPlayerButtonOverlayText>
              </OpenPlayerButtonOverlay>
            </OpenPlayerButton>
          )}
        </div>
      </>
    );
  }

  public openPlayer = () => {
    document.location.hash = 'video';
  };

  public closePlayer = () => {
    document.location.hash = '';
  };

  public handleHashChange = () => {
    this.setState({ isPlayerOpen: document.location.hash === '#video' });
  };

  public handleKeyDown = (e) => {
    if (isHotkey('esc', e)) {
      this.closePlayer();
      e.preventDefault();
      e.stopPropagation();
    }
  };
}

export default ArticleFactcheckVideoApp;

const OpenPlayerButton = styled.button`
  display: block;
  position: absolute;
  width: 100%;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: 0;
  padding: 0;
  border: none;
  background: none;
  cursor: pointer;
`;

const OpenPlayerButtonOverlay = styled.div`
  position: absolute;
  left: 50%;
  top: 50%;
  margin-left: -115px;
  margin-top: -35px;
  width: 230px;
  height: 70px;
  background-color: rgba(40, 40, 40, 0.8);
  display: flex;
  flex-direction: row;
  align-items: center;
`;

const OpenPlayerButtonOverlayPlayIcon = styled.img`
  margin-left: 20px;
`;

const OpenPlayerButtonOverlayText = styled.div`
  margin-left: 15px;
  margin-right: 20px;
  color: white;
  font-size: 14px;
  line-height: 1.25;
  font-family: Lato, sans-serif;
  font-weight: normal;
  text-align: left;
`;

interface IPlayerProps {
  article: IArticleStatementsQueryResult['article'];
  onRequestClose: () => void;
}

interface IPlayerState {
  highlightStatementId: string | null;
  time: number;
}

class Player extends React.Component<IPlayerProps, IPlayerState> {
  public video: IVideo | null = null;
  public getVideoTimeIntervalHandle: number | null = null;
  public statementsColumn: HTMLDivElement | null = null;
  public statementContainers: { [statementId: string]: HTMLDivElement } = {};
  public headMetaViewport: HTMLMetaElement | null = null;
  public headMetaViewportContentBefore: string | null = null;
  public state: IPlayerState = {
    highlightStatementId: null,
    time: 0,
  };

  public componentDidMount() {
    document.body.style.position = 'fixed';

    this.headMetaViewport = document.head.querySelector('meta[name=viewport]');
    if (this.headMetaViewport) {
      this.headMetaViewportContentBefore = this.headMetaViewport.getAttribute('content');
      this.headMetaViewport.setAttribute('content', 'width=800');
    }

    this.getVideoTimeIntervalHandle = window.setInterval(this.getVideoTime, 100);
  }

  public componentWillUnmount() {
    document.body.style.position = null;

    if (this.headMetaViewport && this.headMetaViewportContentBefore) {
      this.headMetaViewport.setAttribute('content', this.headMetaViewportContentBefore);
    }

    if (this.getVideoTimeIntervalHandle !== null) {
      window.clearInterval(this.getVideoTimeIntervalHandle);
      this.getVideoTimeIntervalHandle = null;
    }
  }

  public componentDidUpdate(_, prevState) {
    if (prevState.time !== this.state.time && this.state.time !== null) {
      const foundStatement = this.props.article.statements.find((statement) => {
        const timing = timings[statement.id];

        if (timing) {
          return (
            this.state.time >= parseTimingTime(timing[0]) &&
            this.state.time <= parseTimingTime(timing[1])
          );
        } else {
          return false;
        }
      });

      this.setState({
        highlightStatementId: foundStatement ? foundStatement.id : null,
      });
    }

    if (
      prevState.highlightStatementId !== this.state.highlightStatementId &&
      this.state.highlightStatementId !== null &&
      this.statementsColumn !== null &&
      this.statementContainers[this.state.highlightStatementId] !== undefined
    ) {
      this.statementsColumn.scroll({
        top: this.statementContainers[this.state.highlightStatementId].offsetTop - 15,
        left: 0,
        behavior: 'smooth',
      });
    }
  }

  public render() {
    const { article, onRequestClose } = this.props;
    const { highlightStatementId } = this.state;

    const statementsSortedByTimingsStart = orderBy(
      article.statements.filter((s) => !!timings[s.id]),
      [(s) => parseTimingTime(timings[s.id][0])],
      ['asc'],
    );

    return (
      <div
        className={css`
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: #f4f9fd;
          z-index: 100;
          min-width: 800px;
        `}
      >
        <HeaderBar>
          <a
            href="/"
            className={css`
              margin-left: 15px;
            `}
          >
            <img src={demagogLogoIconOnly} alt="Demagog.cz" />
          </a>
          <h1
            className={css`
              margin: 0 0 0 15px;
            `}
          >
            {article.title}
          </h1>

          <HeaderBarCloseButton type="button" onClick={onRequestClose}>
            <HeaderBarCloseButtonIcon>×</HeaderBarCloseButtonIcon> Zavřít přehrávač
          </HeaderBarCloseButton>
        </HeaderBar>
        <VideoColumn>
          <YoutubeVideo onReady={this.onVideoReady} videoId="LHX2OdsApCc" />
        </VideoColumn>
        <StatementsColumn ref={(statementsColumn) => (this.statementsColumn = statementsColumn)}>
          {statementsSortedByTimingsStart.map((statement, index) => {
            const timing = timings[statement.id];
            const highlighted = highlightStatementId === statement.id;
            const lastStatement = index + 1 === statementsSortedByTimingsStart.length;
            return (
              <StatementContainer
                key={statement.id}
                highlighted={highlighted}
                ref={(container) => (this.statementContainers[statement.id] = container)}
              >
                <TimeContainer>
                  <TimeButton
                    type="button"
                    onClick={() => this.goToTimeOfStatement(statement.id)}
                    data-tip={`Kliknutím skočte na čas ${timing[0]}`}
                    data-for={`statement-${statement.id}`}
                  >
                    {timing[0]}
                  </TimeButton>
                  <ReactTooltip place="top" id={`statement-${statement.id}`} effect="solid" />
                  {!lastStatement && <TimeLine />}
                </TimeContainer>
                <div
                  className={css`
                    flex: 1;
                  `}
                >
                  <DisplayStatement highlighted={highlighted} statement={statement} />
                </div>
              </StatementContainer>
            );
          })}
        </StatementsColumn>
      </div>
    );
  }

  public onVideoReady = (video: IVideo) => {
    this.video = video;
  };

  public getVideoTime = () => {
    if (this.video !== null) {
      this.setState({ time: this.video.getTime() });
    }
  };

  public goToTimeOfStatement = (statementId: string) => {
    const timing = timings[statementId];
    if (this.video !== null && timing) {
      this.video.goToTime(parseTimingTime(timing[0]));
    }
  };
}

const HeaderBar = styled.div`
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 60px;
  border-bottom: 2px solid #d8e1e8;
  display: flex;
  flex-direction: row;
  align-items: center;
`;

const HeaderBarCloseButton = styled.button`
  display: block;
  margin: 0 15px 0 auto;
  padding: 0 15px;
  border: none;
  background: none;
  color: #f26538;
  font-size: 18px;
  line-height: 1.2;
  font-family: Lato, sans-serif;
  font-weight: bold;
  cursor: pointer;

  &:hover,
  &:active {
    color: #3c325c;
  }
`;

const HeaderBarCloseButtonIcon = styled.span`
  font-size: 22px;
  line-height: 1;
  margin-right: 2px;
`;

const VideoColumn = styled.div`
  position: absolute;
  top: 62px;
  bottom: 0;
  left: 0;
  right: 60%;
  padding-top: 15px;

  @media (min-width: 1200px) {
    right: 50%;
  }
`;

const StatementsColumn = styled.div`
  position: absolute;
  top: 62px;
  bottom: 0;
  left: 40%;
  right: 0;
  overflow-y: auto;
  overflow-x: hidden;
  padding-left: 15px;
  padding-right: 15px;
  padding-bottom: 400px;

  @media (min-width: 1200px) {
    left: 50%;
  }
`;

const TimeContainer = styled.div`
  flex: 0 0 60px;
  padding: 0 5px;
  position: relative;
`;

const TimeButton = styled.button`
  display: block;
  padding: 9px 0;
  width: 100%;
  background: none;
  border: none;
  font-family: Lato, sans-serif;
  font-size: 16px;
  font-weight: normal;
  color: #f26538;
  cursor: pointer;
  text-align: center;

  &:hover,
  &:active {
    text-decoration: underline;
  }
`;

const TimeLine = styled.div`
  position: absolute;
  top: 39px;
  bottom: -46px;
  left: 50%;
  margin-left: -1px;
  border-left: 2px solid #d8e1e8;
`;

const StatementContainer = styled.div`
  display: flex;
  margin-top: 15px;
  margin-bottom: 15px;
  background-color: ${(props: any) => (props.highlighted ? '#FAE4DD' : 'transparent')};
  padding: 13px 15px 18px 0;
`;

// TODO: move to server
const timings = {
  18598: ['0:46', '1:03'],
  18599: ['1:06', '1:12'],
  18601: ['2:33', '3:01'],
  18602: ['3:19', '3:32'],
  18603: ['4:12', '4:25'],
  18604: ['4:43', '5:15'],
  18605: ['5:19', '5:47'],
  18606: ['6:57', '7:08'],
  18607: ['7:09', '7:41'],
  18608: ['7:44', '8:03'],
  18609: ['8:03', '8:15'],
  18610: ['9:15', '9:21'],
  18611: ['9:24', '9:40'],
  18612: ['9:41', '9:43'],
  18614: ['9:53', '9:56'],
  18615: ['10:17', '10:24'],
  18616: ['10:34', '11:05'],
  18617: ['11:23', '11:25'],
  18618: ['12:42', '12:50'],
  18620: ['14:02', '14:13'],
  18619: ['14:33', '14:39'],
  18621: ['15:42', '16:00'],
  18622: ['18:12', '18:16'],
  18623: ['18:31', '18:48'],
  18624: ['18:52', '18:55'],
  18625: ['19:50', '20:15'],
  18626: ['21:25', '21:31'],
};

const parseTimingTime = (time: string): number => {
  if (typeof time === 'number') {
    return time;
  }

  const parts = time.split(':');

  let seconds = 0;
  if (parts.length > 0) {
    // Float, because seconds can be '1.3'
    seconds += parseFloat(parts.pop() as string);
  }
  if (parts.length > 0) {
    seconds += parseInt(parts.pop() as string, 10) * 60;
  }
  if (parts.length > 0) {
    seconds += parseInt(parts.pop() as string, 10) * 3600;
  }

  return seconds;
};

interface IDisplayStatementProps {
  highlighted: boolean;
  statement: IArticleStatementsQueryResult['article']['statements'][0];
}

interface IDisplayStatementState {
  showExplanation: boolean;
}

class DisplayStatement extends React.Component<IDisplayStatementProps, IDisplayStatementState> {
  public explanationContainer: HTMLDivElement | null = null;
  public state = {
    showExplanation: false,
  };

  public componentDidUpdate(_, prevState) {
    if (
      !prevState.showExplanation &&
      this.state.showExplanation &&
      this.explanationContainer !== null
    ) {
      // Make sure the links in explanation are opened in new window
      this.explanationContainer.querySelectorAll('a').forEach((el) => {
        el.setAttribute('target', '_blank');
      });
    }
  }

  public render() {
    const { highlighted, statement } = this.props;
    const { showExplanation } = this.state;
    const speakerFullName = `${statement.speaker.firstName} ${statement.speaker.lastName}`;

    return (
      <div>
        <SpeakerContainer>
          <SpeakerAvatarMask>
            <img src={statement.speaker.avatar} alt={speakerFullName} />
          </SpeakerAvatarMask>
          <SpeakerFullName>{speakerFullName}</SpeakerFullName>
        </SpeakerContainer>
        <StatementContent
          important={statement.important}
          highlighted={highlighted}
          dangerouslySetInnerHTML={{ __html: convertNewlinesToBr(statement.content) }}
        />
        <VeracityContainer>
          <span className={'veracity-label ' + statement.assessment.veracity.key}>
            {' '}
            {statement.assessment.veracity.name}
          </span>
        </VeracityContainer>
        <ShortExplanationContainer>
          <p>{statement.assessment.shortExplanation}</p>
        </ShortExplanationContainer>
        <ToggleExplanationButton type="button" onClick={this.toggleExplanation}>
          {showExplanation ? 'skrýt' : 'zobrazit'} celé odůvodnění
        </ToggleExplanationButton>
        {showExplanation && (
          <ExplanationContainer
            dangerouslySetInnerHTML={{ __html: statement.assessment.explanationHtml }}
            ref={(explanationContainer) => (this.explanationContainer = explanationContainer)}
          />
        )}
      </div>
    );
  }

  public toggleExplanation = () => {
    this.setState({ showExplanation: !this.state.showExplanation });
  };
}

const SpeakerContainer = styled.div`
  display: flex;
  align-items: center;
`;

const SpeakerAvatarMask = styled.div`
  width: 36px;
  height: 36px;
  border-radius: 50%;
  overflow: hidden;
`;

const SpeakerFullName = styled.h3`
  margin: 0 0 0 8px;
`;

const StatementContent = styled.blockquote`
  background-color: ${(props: any) => getStatementContentColor(props)};
  border-radius: 5px;
  padding: 8px 15px 10px;
  margin: 14px 0 0 0;
  letter-spacing: 0;
  position: relative;

  &:after {
    content: ' ';
    position: absolute;
    bottom: 100%;
    left: 9px;
    height: 0;
    width: 0;
    border: solid transparent;
    border-bottom-color: ${(props: any) => getStatementContentColor(props)};
    border-width: 9px;
    pointer-events: none;
  }
`;

const getStatementContentColor = ({ highlighted, important }) => {
  let color = '#d7e5ef';
  if (important) {
    color = '#f3dbd3';
  }
  if (highlighted) {
    color = '#f4f9fd';
  }
  return color;
};

const VeracityContainer = styled.div`
  margin-top: 13px;
`;

const ShortExplanationContainer = styled.div`
  margin-top: 5px;

  p {
    margin: 0;
  }
`;

const ToggleExplanationButton = styled.button`
  display: block;
  margin: 5px 0 0 0;
  padding: 0;
  border: none;
  background: none;
  color: #f26538;
  font-size: 16px;
  font-family: Lato, sans-serif;
  font-weight: normal;
  cursor: pointer;

  &:hover,
  &:active {
    text-decoration: underline;
  }
`;

const ExplanationContainer = styled.div`
  margin-top: 5px;
`;

export const convertNewlinesToBr = (text) => text.replace(/(?:\r\n|\r|\n)/g, '<br />');
