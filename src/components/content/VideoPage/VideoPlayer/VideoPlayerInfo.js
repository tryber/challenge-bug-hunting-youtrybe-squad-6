import React, { Component } from 'react';

class VideoPlayerInfo extends Component {

  render() {
    const { title, statisticsInfo } = this.props;
    return (
      <div data-testid='videoinfo' className="video-info">
        <h1 className="title">
          {title}
        </h1>
        <div className="video-toolbar">
          <span className="video-views">
            {statisticsInfo.viewCount} views
        </span>
          <span className="right-menu">
            <div className="thumb-wrapper">
              <div className="thumb-up-btn">
                <i className="material-icons">thumb_up</i>
                <span className="thumbs-count">
                  {statisticsInfo.likeCount}
                </span>
              </div>

              <div className="thumb-down-btn">
                <i className="material-icons">thumb_down</i>
                <span className="thumbs-count">
                  {statisticsInfo.dislikeCount}
                </span>
              </div>
            </div>

            <div className="share-btn">
              <i className="material-icons">reply</i>
              <span>SHARE</span>
            </div>

            <div className="save-btn">
              <i className="material-icons">playlist_add</i>
              <span>SAVE</span>
            </div>
            <div className="options-btn">
              <i className="material-icons">more_horiz</i>
            </div>
          </span>
        </div>
      </div>
    );
  }
}

export default VideoPlayerInfo;