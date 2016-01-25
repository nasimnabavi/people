import Filters from './Filters';
import * as FilterTabs from '../../constants/scheduling/FilterTabs';

export default class FilteringService {
  static prepareDefaultData(users) {
    return Filters.selectAll(users);
  }

  static filter(usersToView, store) {
    if(store.userIds.length !== 0) {
      usersToView = Filters.selectUsers(usersToView, store);
    }
    if(store.roleIds.length !== 0) {
      usersToView = Filters.selectRoles(usersToView, store);
    }
    if(store.abilityIds.length !== 0) {
      usersToView = Filters.selectAbilities(usersToView, store);
    }

    return usersToView;
  }
}
