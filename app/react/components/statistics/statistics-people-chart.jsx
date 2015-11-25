import React from 'react';

class StatisticsPeopleChart extends React.Component {
  static get propTypes() {
    return {
      billableCount: React.PropTypes.number.isRequired,
      internalsCount: React.PropTypes.number.isRequired,
      nonBillableInCommercialProjectsCount: React.PropTypes.number.isRequired,
      juniorsAndInternsCount: React.PropTypes.number.isRequired
    };
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip()
  }

  _percentToS(percent) {
    return percent + '%';
  }

  render() {
    const sumOfAllDevelopers = this.props.billableCount + this.props.internalsCount +
      this.props.nonBillableInCommercialProjectsCount + this.props.juniorsAndInternsCount;
    const billablePercentage = ((this.props.billableCount /
      sumOfAllDevelopers) * 100).toFixed(1);
    const internalsPercentage = ((this.props.internalsCount /
      sumOfAllDevelopers) * 100).toFixed(1);
    const nonBillableInCommercialProjectsPercentage = ((this.props.nonBillableInCommercialProjectsCount /
      sumOfAllDevelopers) * 100).toFixed(1);
    const juniorsAndInternsPercentage = (100 - billablePercentage - internalsPercentage -
      nonBillableInCommercialProjectsPercentage).toFixed(1);

    return (
      <div className='progress'>
        <div className='progress-bar progress-bar-success'
          style={{width: this._percentToS(billablePercentage)}} data-toggle='tooltip'
          data-original-title={'billable: ' + this._percentToS(billablePercentage)}></div>
        <div className='progress-bar progress-bar-info'
          style={{width: this._percentToS(internalsPercentage)}} data-toggle='tooltip'
          data-original-title={'internals: ' + this._percentToS(internalsPercentage)}></div>
        <div className='progress-bar progress-bar-danger'
          style={{width: this._percentToS(nonBillableInCommercialProjectsPercentage)}} data-toggle='tooltip'
          data-original-title={'non-billable commercial: ' + this._percentToS(nonBillableInCommercialProjectsPercentage)}></div>
        <div className='progress-bar progress-bar-primary'
          style={{width: this._percentToS(juniorsAndInternsPercentage)}} data-toggle='tooltip'
          data-original-title={'juniors/interns: ' + this._percentToS(juniorsAndInternsPercentage)}></div>
      </div>
    );
  }
}

export default StatisticsPeopleChart;
