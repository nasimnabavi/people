import React from 'react';
import NestedStatistic from './nested-statistic';

class NestedStatistics extends React.Component {
  static get propTypes() {
    return {
      name: React.PropTypes.string.isRequired,
      statisticsArrays: React.PropTypes.array.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = { display: false, displayNested: false };
    this.onStatisticClick = this.onStatisticClick.bind(this);
  }

  onStatisticClick() {
    this.setState({ display: !this.state.display });
  }

  render() {
    const peopleArrays = this.props.statisticsArrays.map((statistic) => statistic.people);
    const arrayLength = [].concat.apply([], peopleArrays).length;
    const statistics = this.props.statisticsArrays.map((statistic) =>
      <NestedStatistic name={statistic.name} people={statistic.people} key={statistic.name}/>
    );
    const data = arrayLength > 0 ?
      statistics : <tr><td colSpan='2'><h6>No data for given period</h6></td></tr>;

    return (
      <tbody>
        <tr className='statistic-row' onClick={this.onStatisticClick}>
          <td>{this.props.name}</td>
          <td>{arrayLength}</td>
        </tr>
        {this.state.display ? data : null}
      </tbody>
    );
  }
}

export default NestedStatistics;
