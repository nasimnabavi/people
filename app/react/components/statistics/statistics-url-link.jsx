import React, {PropTypes} from 'react';
import CopyToClipboard from 'react-copy-to-clipboard';

export default class StatisticsUrlLink extends React.Component {
  render() {
    const domain = window.location.href.split('/')[2];
    const urlValue = domain +
      Routes.statistics_path({start: this.props.startDate, end: this.props.endDate});
    return(
      <CopyToClipboard text={urlValue}
          onCopy={() => Messenger().success("URL copied to clipboard")}>
          <div id="copy-link-btn" className='pull-right btn btn-info btn-xs'>
            <span className='glyphicon glyphicon-file'></span>
            Copy URL for sharing
          </div>
      </CopyToClipboard>
    );
  }
}

StatisticsUrlLink.propTypes = {
  startDate: PropTypes.string.isRequired,
  endDate: PropTypes.string.isRequired,
};
