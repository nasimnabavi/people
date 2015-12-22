import React, {PropTypes} from 'react';
import FiltersDropdowns from './filters-dropdowns';

export default class Filters extends React.Component {
  render() {
    return(
      <div id="filters">
        <FiltersDropdowns />
      </div>
    );
  }
}
