import React, {PropTypes} from 'react';

export default class StatisticsPeopleRow extends React.Component {
  internsCount() {
    return this.props.interns ? this.props.interns.length : 0;
  }
  juniorsCount() {
    return this.props.juniors ? this.props.juniors.length : 0;
  }
  regularsCount() {
    return this.props.regulars ? this.props.regulars.length : 0;
  }
  seniorsCount() {
    return this.props.seniors ? this.props.seniors.length : 0;
  }
  allDevelopersCount() {
    return this.internsCount() + this.juniorsCount() + this.regularsCount() + this.seniorsCount();
  }
  
  render() {
    return(
      <tr>
        <td>{this.props.label}</td>
        <td>{this.internsCount()}</td>
        <td>{this.juniorsCount()}</td>
        <td>{this.regularsCount()}</td>
        <td>{this.seniorsCount()}</td>
        <td>{this.allDevelopersCount()}</td>
      </tr>
    );
  }
}

StatisticsPeopleRow.propTypes = {
  label: PropTypes.string,
  interns: PropTypes.array,
  juniors: PropTypes.array,
  regulars: PropTypes.array,
  seniors: PropTypes.array
};
