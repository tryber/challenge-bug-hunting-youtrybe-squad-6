import React, { Component } from "react";
import VideoCard from "./VideoCard/VideoCard";
import { Link } from "react-router-dom";

import "../../../css/sideBar.css";
import { searchVideos } from "../../../api/service";

class SearchResult extends Component {
  constructor(props) {
    super(props);

    this.state = {
      data: [],
      error: "",
    };
  }

  componentDidMount() {
    const { searchParam } = this.props.match.params;

    searchVideos(searchParam)
      .then((data) => {
        this.setState({ data: data.items.slice(0, 24) }); // porque não funciona limitar a quantidade direto na requisição?
      })
      .catch((error) => this.setState({ error: error }));
  }

  render() {
    const { data } = this.state;
    if (data.length < 1) return <div>Loading...</div>;

    return (
      <div>
        {data.map((item, index) => (
          <Link
            className="thumbnail-card"
            key={index}
            to={{
              pathname: `/watch/${item.id.videoId}`,
              state: { data: data },
            }}
          >
            <VideoCard key={index} video={item} />
          </Link>
        ))}
      </div>
    );
  }
}

export default SearchResult;
