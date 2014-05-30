OSM.Changeset = function (map) {
  var page = {};

  page.pushstate = page.popstate = function(path, id) {
    OSM.loadSidebarContent(path, function() {
      addChangeset(id);
    });
  };

  page.load = function(path, id) {
    addChangeset(id, true);
  };

  function addChangeset(id, center) {
    var bounds = map.addObject({type: 'changeset', id: parseInt(id)}, function(bounds) {
      if (!window.location.hash && bounds.isValid() &&
          (center || !map.getBounds().contains(bounds))) {
        OSM.router.withoutMoveListener(function () {
          map.fitBounds(bounds);
        });
      }
    });
  }

  page.unload = function() {
    map.removeObject();
  };

  return page;
};