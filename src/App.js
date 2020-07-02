import React, { Component } from 'react';
import { Switch, Route, Router } from 'react-router-dom';

import './App.css';
import './css/mainContents.css';

import Header from './components/header/Header';
import VideoPage from './components/content/VideoPage/VideoPage';
import SearchResult from './components/content/SearchResult';
import NotFound from './components/content/NotFound';
import InitialPage from './components/content/InitialPage';

class App extends Component {
  render() {
    return (
      <Router> 
        <div className="App">
          <Header />
          <Switch>
            <Route path="/"><InitialPage /></Route>
            <Route
              exact path="/watch/:videoId"
              render={(props) => <VideoPage {...props} />}
            />
            <Route
              exact path="/results/:searchParam"
              render={(props) => <SearchResult {...props} />}
            />
            <Route path="*"><NotFound /></Route>
          </Switch>
        </div>
      </Router>
    );
  }
};

export default App;
