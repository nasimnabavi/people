import React from 'react';
import classNames from 'classnames';
import Detail from './detail';


class Statistic extends React.Component {
  static get propTypes() {
    return {
      name: React.PropTypes.string.isRequired,
      detailsArray: React.PropTypes.array.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = { display: false };
    this.onStatisticClick = this.onStatisticClick.bind(this);
  }

  onStatisticClick() {
    this.setState({ display: !this.state.display });
  }

  render() {
    const arrayLength = this.props.detailsArray.length;
    const list = this.props.detailsArray.map((detail) =>
      <Detail name={detail.name} url={detail.url} key={detail.id}/>
    );
    const details = (
      <tr>
        <td colSpan='2'>
          {arrayLength > 0 ? <ul className='details-list'>{list}</ul> : <h6>No data for given period</h6>}
        </td>
      </tr>
    );
    const stClassName = classNames('statistic-row', { opened: this.state.display });

    return (
      <tbody>
        <tr className={stClassName} onClick={this.onStatisticClick}>
          <td>{this.props.name}</td>
          <td>{arrayLength}</td>
        </tr>
        {this.state.display ? details : null}
      </tbody>
    );
  }
}

export default Statistic;
