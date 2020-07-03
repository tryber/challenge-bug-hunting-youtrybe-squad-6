import React, { Component } from 'react';

import '../../../../css/searchResult.css';

class VideoCard extends Component {
  constructor(props) {
    super(props);

    this.state = {};
  }
  render() {
    const { id, snippet } = this.props.video;
    return (
      <div className="suggested-video search-result">
        <div className="thumbnail">
          <img
            alt="thumbnail"
            src={snippet.thumbnails.medium.url}
          />
          {id.kind === 'youtube#video' ? <span>17:30</span> : null}
        </div>

        <div className="thumbnail-info">
          <h2>{snippet.title}</h2>
          <div className="channel">{snippet.channelTitle}</div>
          {id.kind === 'youtube#video' ? <div className="views">792K views</div> : null}
          <p className="description">{snippet.description}</p>
        </div>
      </div>
    );
  }
}

export default VideoCard;
