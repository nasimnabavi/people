import React from 'react';

class Statistic extends React.Component {
  static get propTypes() {
    return {
      name: React.PropTypes.string.isRequired,
      number: React.PropTypes.number.isRequired,
    };
  }

  render() {
    return (
      <tr>
        <td>{this.props.name}</td>
        <td>{this.props.number}</td>
      </tr>
    );
  }
}

export default Statistic;
