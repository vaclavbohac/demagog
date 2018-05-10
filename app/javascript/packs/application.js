/* eslint-env browser */

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'intersection-observer/intersection-observer';

window.jQuery = require('jquery');
require('zurb-foundation-5/js/foundation/foundation');
require('zurb-foundation-5/js/foundation/foundation.topbar');

document.addEventListener('DOMContentLoaded', () => {
  /**
   * Find closest parent of given element that has className
   * @param {HTMLElement} elem
   * @param {string} className
   * @return {HTMLElement}
   */
  function findClosest(elem, className) {
    // eslint-disable-next-line no-param-reassign
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
    const parent = findClosest(event.target, 'reasons');

    if (parent) {
      parent.classList.remove('hidden');
    }

    event.preventDefault();
    event.stopPropagation();
  }

  [].slice.call(document.querySelectorAll('.show-reasons'))
    .forEach((elem) => {
      elem.addEventListener('click', showAssessment);
    });

  /**
   * Render images if they are in the view port
   * @param {IntersectionObserverEntry[]} entries
   */
  function renderIntersectingImages(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.setAttribute('src', entry.target.getAttribute('data-src'));
      }
    });
  }

  const io = new IntersectionObserver(renderIntersectingImages);

  [].slice.call(document.querySelectorAll('img.lazy-load'))
    .forEach(io.observe.bind(io));

  window.jQuery(document).foundation();
});
