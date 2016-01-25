import React, {PropTypes} from 'react';

export default class NewNoteForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      noteText: ''
    };
    this.saveNote = this.saveNote.bind(this);
  }

  saveNote() {
    const failedToSaveNote = () => {
      debugger;
    };

    $.ajax({
      url: Routes.notes_path(),
      type: "POST",
      dataType: "json",
      data: {
        note: {
          text: this.state.noteText,
          project_id: this.props.projectId,
          user_id: gon.current_user.id
        }
      }
    }).done(this.props.noteAddedCallback).fail(failedToSaveNote);

    $('input.new-project-note-text').val('');
  }

  render() {
    const changeNoteText = (e) => this.setState({ noteText: e.target.value });

    return(
      <div className='new-project-note input-group'>
        <input className="form-control new-project-note-text"
          type="text"
          placeholder='Type your note...'
          onChange={changeNoteText} />
        <span className='input-group-btn' onClick={this.saveNote}>
          <a className='btn btn-primary new-project-note-submit'>Save changes</a>
        </span>
      </div>
    );
  }
}

NewNoteForm.propTypes = {
  projectId: PropTypes.number.isRequired,
  noteAddedCallback: PropTypes.func.isRequired
};
