import React, { Component } from 'react';
import { Switch, Route, BrowserRouter } from 'react-router-dom';

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
      <BrowserRouter> 
        <div className="App">
          <Header />
          <Switch>
            <Route exact path="/" component={InitialPage} />
            <Route
              path="/watch/:videoId"
              render={(props) => <VideoPage {...props} />}
            />
            <Route
              path="/results/:searchParam"
              render={(props) => <SearchResult {...props} />}
            />
            <Route path='/' componente={NotFound} />
          </Switch>
        </div>
      </BrowserRouter>
    );
  }
};

export default App;
