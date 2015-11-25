import React from 'react';

class StatisticsPeopleChart extends React.Component {
  static get propTypes() {
    return {
      billableCount: React.PropTypes.number.isRequired,
      internalsCount: React.PropTypes.number.isRequired,
      nonBillableInCommercialProjectsCount: React.PropTypes.number.isRequired
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
      this.props.nonBillableInCommercialProjectsCount;
    const billablePercentage = ((this.props.billableCount /
      sumOfAllDevelopers)*100).toFixed(1);
    const internalsPercentage = ((this.props.internalsCount /
      sumOfAllDevelopers)*100).toFixed(1);
    const nonBillableInCommercialProjects = (100 - billablePercentage - internalsPercentage).toFixed(1);
    
    return (
      <div className='progress'>
        <div className='progress-bar progress-bar-success'
          style={{width: this._percentToS(billablePercentage)}} data-toggle='tooltip'
          data-original-title={'commerical: ' + this._percentToS(billablePercentage)}></div>
        <div className='progress-bar progress-bar-info'
          style={{width: this._percentToS(internalsPercentage)}} data-toggle='tooltip'
          data-original-title={'internal: ' + this._percentToS(internalsPercentage)}></div>
        <div className='progress-bar progress-bar-danger'
          style={{width: this._percentToS(nonBillableInCommercialProjects)}} data-toggle='tooltip'
          data-original-title={'maintenance: ' + this._percentToS(nonBillableInCommercialProjects)}></div>
      </div>
    );
  }
}

export default StatisticsPeopleChart;
