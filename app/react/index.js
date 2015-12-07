window.React = require('react');

import ReactDOM from 'react-dom';
window.ReactDOM = ReactDOM;

import Statistics from './components/statistics/statistics';
import Teams from './components/teams/teams';
import Projects from './components/projects/projects';
import Users from './components/users/users';

registerComponent('statistics', Statistics);
registerComponent('teams', Teams);
registerComponent('projects', Projects);
registerComponent('users', Users);
