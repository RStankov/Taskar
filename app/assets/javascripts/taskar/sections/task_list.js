Taskar.Sections.TaskList = {
  initialize: function(element) {
    if (!element.down('.task')) {
      $('new_task').show().down('textarea').highlight().focus();
    }

    var sectionTitle = $('section_title');
    if (sectionTitle) {
      var checkForArchiveButton = function() {
        var archive = sectionTitle.down('a.archive');
        archive && archive[element.down('li.task') ? 'hide' : 'show']();
      };

      sectionTitle.observe('mouseenter', checkForArchiveButton);

      checkForArchiveButton();
    }

    new Taskar.Dnd.Sortable(element, {
      list:   '#' + element.id,
      item:   'li.task',
      handle: '.drag'
    });
  },
  actions: {
    errorOnNew: function(html) {
      $('new_task').replace(html);
      $('new_task').show().highlight({startColor: Taskar.ERROR_COLOR}).down('textarea').focus();
    },
    create: function(taskId, taskHtml, higherTaskId) {
      var higher = higherTaskId && $('task_' + higherTaskId);
      if (!higher) {
        $("new_task").insert({before: taskHtml});
      } else {
        higher.insert({after: taskHtml});
      }

      $('task_' + taskId).hide().slideDown(function(e){
        new Taskar.FX.ScrollTo(e.element);
      });
      Taskar.Sections.resetTaskForm($('new_task').down('form').show(), taskId);
    },
    edit: function(elementId, html) {
      $(elementId).transform(html);
    },
    show: function(elementId, inListHtml, inShowActionHtml) {
      $(elementId).replaceWithEffect($("task_title") ? inShowActionHtml : inListHtml);
    }
  },
  behaviors: {
    click: {
      'input.cancel': function(e, element){
        e.findElement('li').slideUp();
      },
      '.add': function(e, element){
        e.stop();

        function insertBefore(){
          var before = element.getAttribute('data-after'),
              scroll = false;

          if (before){
            task.insert({after: newTask});
          } else {
            $('tasks').insert({bottom: newTask});
            scroll = true;
          }

          Taskar.Sections.resetTaskForm(newTask.down('form'), before, true);

          newTask.slideDown(function(e){
            e.element.down('textarea').focus();
            scroll && new Taskar.FX.ScrollTo(e.element);
          });
        }

        element.hide();
        element.show.bind(element).defer();

        var newTask  = $('new_task'),
            task     = element.up('.task');

        if (!newTask.visible()){
          insertBefore();
        } else {
          if (task && task.next() == newTask){
            newTask.down('textarea').focus();
          } else {
            newTask.slideUp(insertBefore);
          }
        }
      },
      '.toggle_archived': function(e, element){
        e.stop();

        var archive = $('archived_tasks');
        if (archive){
          element.toggleClassName('selected');
          return archive.toggleWithEffect('slide', function(e){
            if (archive.visible()){
              new Taskar.FX.ScrollTo(element);
            }
          });
        }

        element.addClassName('loading');

        new Ajax.Request(element.getAttribute('data-url'), {
          method:     'get',
          onComplete: function(t){
            element.removeClassName('loading');
            element.addClassName('selected');
            e.findElement('footer').insert({ after: t.responseText });
            $('archived_tasks').hide().slideDown(function(e){ new Taskar.FX.ScrollTo(element); });
          }
        });
      }
    },
    'drag:start': {
      '.tasks_list': function(e, element){
        element.addClassName('dragging');
      },
      '.task': function(e, element){
        element.addClassName('dragging');
      }
    },
    'drag:move': {
      '.task': function(e, element){
        Taskar.UI.HoverBubble.move(e.memo.originalEvent);
      }
    },
    'drag:finish': {
      '.tasks_list': function(e, element){
        element.removeClassName('dragging');
      },
      '.task': function(e, element){
        element.removeClassName('dragging');

        Taskar.UI.HoverBubble.hide(e.memo.originalEvent);

        var section = e.memo.originalEvent.findElement('.section');
        if (section && !section.down('.selected')){
          new Ajax.Request(element.getAttribute('data-change-section'), {
            method:     'put',
            parameters: {section_id: section.extractId()}
          });
          element.remove();
        }
      }
    },
    'ajax:post': {
      '#new_task': function(e){
        Taskar.Sections.resetTaskForm(e.findElement('form'));
      }
    },
    'ajax:put': {
      '.archive': function(e){
        var task = e.findElement('.task');

        task.slideUp(function(e){
          var parent, insert, disabled;
          if (task.up('#tasks')){
            parent    = $('archived_tasks');
            insert    = {top: task};
            disabled  = "true";
          } else {
            parent    = $('tasks');
            insert    = {bottom: task};
            disabled  = null;
          }

          task.down('.checkbox').writeAttribute('data-disabled', disabled);

          if (!parent){
            task.remove();
          } else {
            parent.insert(insert);
            task.slideDown();
          }

          task.fire('task:archive_changed');
        });
      }
    },
    'ajax:delete': {
      '.task': function(e, element){
        Taskar.FX.dropOut(element, function(e){ e.element.remove(); });
      }
    },
    'key:esc': {
      '#section_title form':  Taskar.Sections.cancelAction,
      '.task': Taskar.Sections.cancelAction,
      '#new_task': function(e){
        e.findElement('li').slideUp();
      }
    },
    'task:archive_changed': function(e){
      var archive = $('archived_tasks');
      archive && $('archived_tasks_empty')[archive.getElementsByTagName('li').length == 1 ? 'show' : 'hide']();
    }
  }
};