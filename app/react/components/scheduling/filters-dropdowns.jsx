import React, {PropTypes} from 'react';
import Select from 'react-select';
import FiltersDropdown from './filters-dropdown';
import SchedulingUserStore from '../../stores/SchedulingUserStore'
import SchedulingFilterStore from '../../stores/SchedulingFilterStore'
import RoleStore from '../../stores/RoleStore'
import AbilityStore from '../../stores/AbilityStore'
import SchedulingFilterActions from '../../actions/SchedulingFilterActions';

export default class FiltersDropdowns extends React.Component {
  changeUserFilter(objectIds) {
    SchedulingFilterActions.changeUserFilter(objectIds);
  }

  changeRoleFilter(objectIds) {
    SchedulingFilterActions.changeRoleFilter(objectIds);
  }

  changeAbilityFilter(objectIds) {
    SchedulingFilterActions.changeAbilityFilter(objectIds);
  }

  render() {
    const users = SchedulingUserStore.getState().users;
    const userFilerIds = SchedulingFilterStore.getState().userIds;
    const roles = RoleStore.getState().roles;
    const roleFilerIds = SchedulingFilterStore.getState().roleIds;
    const abilities = AbilityStore.getState().abilities;
    const abilityFilerIds = SchedulingFilterStore.getState().abilityIds;

    return(
      <div className="filters">
        <FiltersDropdown
          className="users"
          store_objects={users}
          filter_store_ids={userFilerIds}
          changeFilterAction={this.changeUserFilter} />
        <FiltersDropdown
          className="roles"
          store_objects={roles}
          filter_store_ids={roleFilerIds}
          changeFilterAction={this.changeRoleFilter} />
        <FiltersDropdown
          className="abilities"
          store_objects={abilities}
          filter_store_ids={abilityFilerIds}
          changeFilterAction={this.changeAbilityFilter} />
      </div>
    );
  }
}
