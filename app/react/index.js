window.React = require('react');

import ReactDOM from 'react-dom';
window.ReactDOM = ReactDOM;

import Statistics from './components/statistics';
import Teams from './components/teams/teams';

registerComponent('statistics', Statistics);
registerComponent('teams', Teams);
