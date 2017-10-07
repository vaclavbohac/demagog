// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require intersection-observer-polyfill/dist/IntersectionObserver.global.js
//= require_tree .

document.addEventListener('DOMContentLoaded', function () {
  /**
   * Find closest parent of given element that has className
   * @param {HTMLElement} elem
   * @param {string} className
   * @return {HTMLElement}
   */
  function findClosest(elem, className) {
    for (; elem && elem !== document; elem = elem.parentNode) {
      if (elem.classList.contains(className)) {
        return elem;
      }
    }

    return null;
  }

  /**
   * Shows assessment of given statement
   * @param {Event} event
   */
  function showAssessment(event) {
    var parent = findClosest(event.target, 'reasons');

    if (parent) {
      parent.classList.remove('hidden');
    }

    event.preventDefault();
    event.stopPropagation();
  }

  document
    .querySelectorAll('.show-reasons')
    .forEach(function (elem) {
      elem.addEventListener('click', showAssessment)
    });

  /**
   * Render images if they are in the view port
   * @param {IntersectionObserverEntry[]} entries
   */
  function renderIntersectingImages(entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        entry.target.setAttribute('src', entry.target.getAttribute('data-src'));
      }
    });
  }

  var io = new IntersectionObserver(renderIntersectingImages);

  document
    .querySelectorAll('img.lazy-load')
    .forEach(io.observe.bind(io));
});
