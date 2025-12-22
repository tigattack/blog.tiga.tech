function _getDefaultPackeryOptions() {
  return {
    percentPosition: true,
    gutter: 5,
    resize: true,
  };
}

function _getPackeryOptions(nodeGallery) {
  const defaults = _getDefaultPackeryOptions();
  const {
    packeryGutter,
    packeryPercentPosition,
    packeryResize,
  } = nodeGallery.dataset;

  return {
    percentPosition:
      packeryPercentPosition !== undefined
        ? packeryPercentPosition === "true"
        : defaults.percentPosition,
    gutter:
      packeryGutter !== undefined ? parseInt(packeryGutter, 10) : defaults.gutter,
    resize:
      packeryResize !== undefined ? packeryResize === "true" : defaults.resize,
  };
}

(function init() {
  // Initialize as soon as DOM is ready, not waiting for window.load
  // This gives us earlier access to the gallery elements
  $(function() {
    let packeries = [];
    let nodeGalleries = document.querySelectorAll(".gallery");

    nodeGalleries.forEach((nodeGallery) => {
      // Use imagesLoaded to ensure all images are fully loaded before initializing Packery
      // This prevents layout issues where Packery calculates positions before images have dimensions
      imagesLoaded(nodeGallery, function() {
        let packery = new Packery(nodeGallery, _getPackeryOptions(nodeGallery));
        packeries.push(packery);
        
        // Wait for Packery to finish its initial layout before showing
        packery.on('layoutComplete', function() {
          nodeGallery.classList.add('packery-initialized');
        });
        
        // Trigger initial layout
        packery.layout();
      });
    });
  });
})();
