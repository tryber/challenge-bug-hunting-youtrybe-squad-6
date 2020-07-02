import React, { Component } from 'react';
import { Redirect } from 'react-router-dom';
import VideoPlayer from './VideoPlayer/VideoPlayer';
import VideoPlayerDescription from './VideoPlayer/VideoPlayerDescription';
import VideoPlayerInfo from './VideoPlayer/VideoPlayerInfo';
import VideoPlayerComments from './VideoPlayerComments/VideoPlayerComments';
import VideoSideBar from './VideoSideBar/VideoSideBar';
import { getVideoInfo, getVideoComments } from './../../../api/service';

class VideoPage extends Component {
  constructor(props) {
    super(props);

    this.state = {
      videoId: this.props.match.params.videoId,
      relatedVideos: this.props.location.state.data,
      videoInfo: null,
      videoComments: null,
      shouldRedirect: false,
    };

    this.handleSelectedVideo = this.handleSelectedVideo.bind(this);
  }

  componentDidMount() {
    getVideoInfo(this.state.videoId).then((data) => this.setState({ videoInfo: data.items[0] }));

    getVideoComments(this.state.videoId).then((data) =>
      this.setState({ videoComments: data.items }),
    );
  }

  handleSelectedVideo(videoId) {
    this.setState({ videoId: videoId });
    getVideoInfo(this.state.videoId).then((data) => this.setState({ videoInfo: data.items[0] }));

    getVideoComments(this.state.videoId).then((data) =>
      this.setState({ videoComments: data.items }),
    );
    this.setState({ shouldRedirect: true });
  }

  render() {
    const { videoId, relatedVideos, videoInfo, videoComments, shouldRedirect } = this.state;
    if (!videoInfo || !videoComments) return <main></main>;
    if (shouldRedirect) {
      this.setState({ shouldRedirect: false });
      return <Redirect to={{ pathname: `/watch/${videoId}`, state: { data: relatedVideos } }} />;
    }

    return (
      <main>
        <section className="player">
          <VideoPlayer embedId={videoId} />
          <VideoPlayerInfo statisticsInfo={videoInfo.statistics} title={videoInfo.snippet.title} />
          <VideoPlayerDescription
            channelTitle={videoInfo.snippet.channelTitle}
            description={videoInfo.snippet.description}
            publishedAt={videoInfo.snippet.publishedAt}
          />
          <VideoPlayerComments
            statisticsInfo={videoInfo.statistics}
            videoComments={videoComments}
          />
        </section>
        <section className="sidebar">
          <VideoSideBar
            relatedVideos={relatedVideos}
            handleSelectedVideo={this.handleSelectedVideo}
          />
        </section>
      </main>
    );
  }
}

export default VideoPage;
