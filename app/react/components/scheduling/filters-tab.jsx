import React, {PropTypes} from 'react';

export default class FiltersTab extends React.Component {
  static get propTypes() {
    return {
      name: React.PropTypes.string.isRequired,
      href: React.PropTypes.string.isRequired,
      number: React.PropTypes.number.isRequired,
    };
  }

  constructor(props) {
    super(props);
  }

  render() {
    return(
      <li className="category">
        <a href={this.props.href} >
          {this.props.name}
          <span className="user-count"> ({this.props.number})</span>
        </a>
      </li>
    );
  }
}
