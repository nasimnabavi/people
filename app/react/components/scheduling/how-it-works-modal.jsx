import React, {PropTypes} from 'react';
import Modal from 'react-modal';

export default class HowItWorksModal extends React.Component {
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
        left                  : '50%',
        right                 : 'auto',
        bottom                : 'auto',
        marginRight           : '-50%',
        transform             : 'translate(-50%, 7%)',
        width                 : '80%',
        padding               : '0'
      }
    };

    const closeModal = () => this.setState({ display: false });
    const openModal = () => this.setState({ display: true });
    const tutorialUrl = "https://github.com/netguru/people/wiki/Detailed-rules-on-how-users-are-categorized-on-the-Scheduling-page%3F";

    const modal = (
      <Modal
        className="modal-dialog modal-md"
        closeTimeoutMS={150}
        isOpen={true}
        onRequestClose={closeModal}
        style={modalStyles}
      >
        <div className="modal-header">
          <button className="close" onClick={closeModal}>x</button>
          <h4 className="modal-title">How are users categorized?</h4>
        </div>
        <div className="modal-body">
          <p>Scheduling view only contains technical employees at the company.</p>
          <h4>All scheduled</h4>
          <p>
            Aggregates users from every other category, except the <strong>Not scheduled</strong> category.
            Users are sorted alphabetically.
          </p>
          <h4>Juniors/interns</h4>
          <p>Users who are either juniors or interns at the company. Users are sorted by time in current project</p>
          <h4>To Rotate</h4>
          <p>
            Users who are in a commercial project without a specified due date (neither on a project nor on their membership).
            Users are sorted by time in current project.
          </p>
          <h4>Internals</h4>
          <p>
            Users who are in an internal project with nothing scheduled in the future, or with another internal project scheduled.
            Users are sorted by time in current project.
          </p>
          <h4>Rotation in progress</h4>
          <p>
            Users who have a commercial project scheduled in the future.
            Users are sorted by time in current project.
          </p>
          <h4>In commercial project with due date</h4>
          <p>
            Users who are in a commercial project and either the project has a due date or their membership in the project has a due date.
            Users are sorted by time in current project.
          </p>
          <h4>Booked</h4>
          <p>
            Users who are booked. A booked user will be taken out of any other category and only appear here.
            Users are sorted by time in current project.
          </p>
          <h4>Unavailable</h4>
          <p>
            Users who are unavailable (either are on holidays or are planning to leave the company).
            Being unavailable is marked by assigning someone to a project named 'unavailable'. It is created by default after visiting the Scheduling page.
          </p>
          <h4>Not scheduled</h4>
          <p>
            Users whose membership in their current project has ended and have nothing scheduled.
            Users whose current project has ended and they have nothing scheduled.
            <strong>Only visible by admins</strong>
          </p>
        </div>
        <div className="modal-footer">
          Detailed rules how users are categorized are available at
          <a href={tutorialUrl} target="_blank"> People wiki on Github</a>
        </div>
      </Modal>
    );

    return(
      <div className="modal-button pull-right" onClick={openModal}>
        <a className="btn">
          How exactly are users categorized?
          { this.state.display ? modal : null }
        </a>
      </div>
    );
  }
}
