import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import youtubeLogo from './../../assets/youlogo.png';

import '../../css/menu.css';

class Menu extends Component {
  render() {
    return (
      <div className="menu">
        <i className="material-icons">menu</i>
        <Link
            to={`/`}
          >
          <img className="youlogo" alt="Youtube logo" src={youtubeLogo} />
        </Link>
      </div>
    );
  }
}

export default Menu;
