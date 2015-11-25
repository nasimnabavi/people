import React from 'react';

class StatisticsProjectsChart extends React.Component {
  static get propTypes() {
    return {
      commercial: React.PropTypes.number.isRequired,
      maintenance: React.PropTypes.number.isRequired,
      internal: React.PropTypes.number.isRequired
    };
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip()
  }

  _percentToS(percent) {
    return percent + '%';
  }

  render() {
    const maintenancePercentage = ((this.props.maintenance /
      (this.props.commercial + this.props.internal + this.props.maintenance))*100).toFixed(1);
    const internalPercentage = ((this.props.internal /
      (this.props.commercial + this.props.internal + this.props.maintenance))*100).toFixed(1);
    const commercialPercentage = (100 - maintenancePercentage - internalPercentage).toFixed(1);

    return (
      <div className='progress'>
        <div className='progress-bar progress-bar-success'
          style={{width: this._percentToS(commercialPercentage)}} data-toggle='tooltip'
          data-original-title={'commerical: ' + this._percentToS(commercialPercentage)}></div>
        <div className='progress-bar progress-bar-info'
          style={{width: this._percentToS(internalPercentage)}} data-toggle='tooltip'
          data-original-title={'internal: ' + this._percentToS(internalPercentage)}></div>
        <div className='progress-bar progress-bar-danger'
          style={{width: this._percentToS(maintenancePercentage)}} data-toggle='tooltip'
          data-original-title={'maintenance: ' + this._percentToS(maintenancePercentage)}></div>
      </div>
    );
  }
}

export default StatisticsProjectsChart;
