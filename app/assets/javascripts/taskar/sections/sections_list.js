Taskar.Sections.SectionsList = {
  initialize: function(container) {
    new Taskar.Dnd.Sortable(container, {
      item:   '.section',
      handle: '.drag',
      moveX:  false,
      moveY:  true
    });

    container.observe('drag:finish', function(e) {
      e.memo.element.setStyle({
        width:  null,
        height: null
      });
    });

    container.on('click',     '.add_section',       show);
    container.on('click',     'h3 a',               showLast);
    container.on('click',     'input[type=button]', hide);
    container.on('key:esc',   'form',               hide);
    container.on('submit',    'form',               Taskar.Sections.validateForm);

    var form    = $('new_section'),
        appear  = new S2.FX.SlideDown(form, function(e) { form.down('input[type=text]').focus(); });

    function show(e, element) {
      e && e.preventDefault();

      form.down('form').reset();
      form.down('input[name*=insert_before]').setValue(element.getAttribute('data-before'));

      if (form.visible()) {
        element.up('li').previous() == form || form.slideUp(showBefore.curry(element));
      } else {
        showBefore(element);
      }
    }

    function showBefore(element) {
      element.hideForASecond();
      element.up('li').insert({before: form});

      appear.play();
    }

    function showLast(e) {
      show(e, container.select('.add_section').last());
    }

    function hide() {
      form.slideUp('fast');
    }

    if (container.select('.section').length == 0) {
      if (!$('sections_new')) {
        showBefore(container.down('.add_section'));
      }
    }
  },
  actions: {
    show: function(titleHtml, descriptionHtml) {
      $("section_title").slideUp(function(e) {
        e.element.update(titleHtml).slideDown();
        if (descriptionHtml.length > 0) {
          e.element.insert({
            after: new Element("p", {className: "text", id: "section_text"}).update(descriptionHtml).hide().slideDown()
          });
        }
      });
    },
    edit: function(html) {
      $("section_title").slideUp(function(e) {
        e.element.update(html).slideDown();
      });
      var text = $("section_text");
      text && text.removeWithEffect("slideUp");
    }
  }
};