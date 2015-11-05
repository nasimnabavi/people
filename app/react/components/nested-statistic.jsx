import React from 'react';
import Detail from './detail';

class NestedStatistic extends React.Component {
  static get propTypes() {
    return {
      name: React.PropTypes.string.isRequired,
      people: React.PropTypes.array.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = { displayInfo: true };
    this.onStatisticClick = this.onStatisticClick.bind(this);
  }

  onStatisticClick() {
    this.setState({ displayInfo: !this.state.displayInfo });
  }

  render() {
    const info = (
    <tr className='statistic-row' onClick={this.onStatisticClick}>
      <td>{this.props.name}</td>
      <td>{this.props.people.length}</td>
    </tr>
    );
    const list = this.props.people.map((detail) =>
      <Detail name={detail.name} url={detail.url} key={detail.id}/>)
    const details = (
    <tr>
      <td colSpan='2'>
        <span className='nested-back-button'>
          <i className='fa fa-lg fa-arrow-circle-left' onClick={this.onStatisticClick}></i>
        </span>
        <ul className='details-list nested-list'>
          {this.props.people.length > 0 ? list : <h6>No data for given period</h6>}
        </ul>
      </td>
    </tr>
    );

    return this.state.displayInfo ? info : details;
  }
}

export default NestedStatistic;
