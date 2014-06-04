OSM.Changeset = function (map) {
  var page = {},
    content = $('#sidebar_content');

  page.pushstate = page.popstate = function(path, id) {
    OSM.loadSidebarContent(path, function() {
      initialize();
      addChangeset(id);
    });
  };

  page.load = function(path, id) {
    initialize();
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

  function updateChangeset(form, method, url) {
    $(form).find("input[type=submit]").prop("disabled", true);

    $.ajax({
      url: url,
      type: method,
      oauth: true,
      data: {text: $(form.text).val()},
      success: function () {
        OSM.loadSidebarContent(window.location.pathname, page.load);
      }
    });
  }

  function initialize() {
    content.find("input[type=submit]").on("click", function (e) {
      e.preventDefault();
      var data = $(e.target).data();
      updateChangeset(e.target.form, data.method, data.url);
    });

    content.find("textarea").on("input", function (e) {
      var form = e.target.form;

      if ($(e.target).val() == "") {
        $(form.comment).prop("disabled", true);
      } else {
        $(form.comment).prop("disabled", false);
      }
    });

    content.find("textarea").val('').trigger("input");
  };

  page.unload = function() {
    map.removeObject();
  };

  return page;
};