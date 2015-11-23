import React, {PropTypes} from 'react';
import Modal from 'react-modal';

export default class StatisticsTutorial extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      display: false
    };
  }

  render() {
    Modal.setAppElement('body');
    const modalStyles = {
      content : {
        top                   : '35%',
        left                  : '50%',
        right                 : 'auto',
        bottom                : 'auto',
        marginRight           : '-50%',
        transform             : 'translate(-50%, -50%)'
      }
    };
    const closeModal = () => this.setState({ display: false });
    const openModal = () => this.setState({ display: true });
    const modal = (
      <Modal
        className="Modal__Bootstrap modal-dialog"
        closeTimeoutMS={150}
        isOpen={true}
        onRequestClose={closeModal}
        style={modalStyles}>
        <div className="modal-header">
          <button type="button" className="close" onClick={closeModal}>
            <span aria-hidden="true">&times;</span>
            <span className="sr-only">Close</span>
          </button>
          <h4 className="modal-title">Statistics tutorial</h4>
        </div>
        <div className="modal-body">
          <p>Statistics can be viewed only by users that have admin privileges.</p>
          <p>You can input date in the datepicker at top of the site. It will fetch statistics for this date range.</p>
          <p>When you click on statistics that have hover effect, you will see projects/users which are counted in this group.</p>
          <p>Positions which are counted on the table at the bottom are counted by primary role which user have.</p>
          <p>You can copy URL by clicking button with "Copy URL for sharing" label. This link will include selected date range.</p>
        </div>
      </Modal>
    );
    return(
      <div id="tutorial-btn" className="btn btn-xs btn-primary modal-button pull-right" onClick={openModal}>
        Show tutorial
        { this.state.display ? modal : null }
      </div>
    );
  }
}
