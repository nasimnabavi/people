import React from 'react';
import moment from 'moment';
import DateRangePicker from 'react-bootstrap-daterangepicker';
import StatisticsUrlLink from './statistics-url-link';

class StatisticsSearch extends React.Component {
  static get propTypes() {
    return {
      onFormSubmit: React.PropTypes.func.isRequired,
      initStartDate: React.PropTypes.string.isRequired,
      initEndDate: React.PropTypes.string.isRequired,
      format: React.PropTypes.string.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      startDate: props.initStartDate,
      endDate: props.initEndDate
    };
    this.onApply = this.onApply.bind(this);
  }

  onApply(e, picker) {
    this.setState({
      startDate: picker.startDate.format(this.props.format),
      endDate: picker.endDate.format(this.props.format)
    });
    this.props.onFormSubmit(this.state.startDate, this.state.endDate);
  }

  render() {
    const ranges = {
      'Last 7 Days': [moment().subtract(6, 'days'), moment()],
      'Last 30 Days': [moment().subtract(29, 'days'), moment()],
      'Last 90 Days': [moment().subtract(89, 'days'), moment()],
      'This Month': [moment().startOf('month'), moment().endOf('month')],
      'Last Month': [
        moment().subtract(1, 'month').startOf('month'),
        moment().subtract(1, 'month').endOf('month')
      ]
    };
    const locale = {
      format: this.props.format,
      separator: ' - ',
      applyLabel: 'Show',
      cancelLabel: 'Cancel',
      fromLabel: 'From',
      toLabel: 'To',
      customRangeLabel: 'Select Dates',
      daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      monthNames: ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'],
      firstDay: 1
    };
    const dateString = 'from  ' + this.state.startDate + '  to  ' + this.state.endDate;
    return (
      <div>
        <DateRangePicker onApply={this.onApply} locale={locale} ranges={ranges} applyClass='btn-primary'
          startDate={moment(this.state.startDate)} endDate={moment(this.state.endDate)}>
          <div className="input-group">
            <span className="input-group-addon"><span className="glyphicon glyphicon-calendar"></span></span>
            <input ref='statisticsDate' className='form-control' type='text' value={dateString}/>
          </div>
        </DateRangePicker>
        <StatisticsUrlLink
          startDate={this.state.startDate}
          endDate={this.state.endDate} />
      </div>
    );
  }
}

export default StatisticsSearch;
