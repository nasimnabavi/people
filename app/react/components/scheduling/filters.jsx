import React, {PropTypes} from 'react';
import FiltersDropdowns from './filters-dropdowns';
import HowItWorksModal from './how-it-works-modal';

export default class Filters extends React.Component {
  render() {
    return(
      <div id="filters">
        <FiltersDropdowns />
        <HowItWorksModal />
      </div>
    );
  }
}
