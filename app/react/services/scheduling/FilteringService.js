import Filters from './Filters';
import Sorting from './Sorting';
import * as FilterTabs from '../../constants/scheduling/FilterTabs';

export default class FilteringService {
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

    switch(store.currentTab) {
      case FilterTabs.ALL:
        usersToView = Filters.selectAll(usersToView);
      break;
      case FilterTabs.JUNIORS_AND_INTERNS:
        usersToView = Filters.selectJuniorsAndInterns(usersToView);
      break;
      case FilterTabs.TO_ROTATE:
        usersToView = Filters.selectToRotate(usersToView);
      break;
      case FilterTabs.INTERNALS:
        usersToView = Filters.selectInternals(usersToView);
      break;
      case FilterTabs.IN_ROTATION:
        usersToView = Filters.selectInRotation(usersToView);
      break;
      case FilterTabs.UNAVAILABLE:
        usersToView = Filters.selectUnavailable(usersToView);
      break;
      case FilterTabs.NOT_SCHEDULED:
        debugger
        usersToView = Filters.selectNotScheduled(usersToView);
      break;
    }

    if(_.contains([FilterTabs.ALL, FilterTabs.NOT_SCHEDULED], store.currentTab)) {
      usersToView = Sorting.sortUsersAlphabetically(usersToView);
    } else {
      usersToView = Sorting.sortByTimeInProject(usersToView);
    }

    return usersToView;
  }
}
