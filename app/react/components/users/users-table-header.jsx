import React, {PropTypes} from 'react';

export default class UsersTableHeader extends React.Component {
  render() {
    return(
      <thead>
        <tr>
          <th></th>
          <th></th>
          <th>
            <p className="columnName">User</p>
          </th>
          <th>
            <p className="columnName">Role</p>
          </th>
          <th>Employment</th>
          <th>Projects</th>
          <th>Admin Role</th>
        </tr>
      </thead>
    );
  }
}

UsersTableHeader.propTypes = {
};
