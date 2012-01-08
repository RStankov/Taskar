Taskar.Sections.Global = {
  behaviors: (function(){
    function loadingOnAjax(e, element) {
      if (element.getAttribute('data-disable') !== 'false') {
        element.addClassName('loading');
        element.getElements().invoke('disable');
      }
    }

    function loadingOnAjaxEdit(e, element) {
      element.addClassName('loading');
      element.style.textDecoration = 'none';
      element.innerHTML = element.innerHTML.gsub(/./, '&nbsp;');
    }

    function removeElement(e) {
      e.element.remove();
    }

    function deleteStatus(e) {
      Taskar.FX.dropOut(e.findElement('li'), removeElement);
    }

    function scrollToTop(e) {
      e.stop();

      var id      = this.getAttribute('href').split('#').last(),
          element = $(id);

      element && new Taskar.FX.ScrollTo(element, function() { location.hash = id; });
    }

    function hideFlash() {
      this.fade().slideUp();
    }

    return {
      'body:ajax:after': {
        '.action_form': loadingOnAjax,
        '.edit':        loadingOnAjaxEdit
      },
      '.flash:click': hideFlash,
      '#statuses_list:ajax:delete': deleteStatus,
      '#scroll_to_top:click': scrollToTop
    };
  })()
};
