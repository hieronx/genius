/**
 * Draggable points plugin
 * Author: Torstein Honsi
 * License: MIT License
 *
 */
 (function (Highcharts) {

        var addEvent = Highcharts.addEvent,
            each = Highcharts.each,
            pick = Highcharts.pick;

        /**
         * Filter by dragMin and dragMax
         */
        function filterRange(newY, series, XOrY) {
            var options = series.options,
                dragMin = pick(options['dragMin' + XOrY], undefined),
                dragMax = pick(options['dragMax' + XOrY], undefined);

            if (newY < dragMin) {
                newY = dragMin;
            } else if (newY > dragMax) {
                newY = dragMax;
            }
            return newY;
        }

        Highcharts.dragdrop = {
            mouseDown: function (e, chart) {
                
                var hoverPoint = chart.hoverPoint,
                    options;

                if (hoverPoint) {
                    options = hoverPoint.series.options;
                    if (options.draggableX) {
                        dragPoint = hoverPoint;

                        dragX = e.changedTouches ? e.changedTouches[0].pageX : e.pageX;
                        dragPlotX = dragPoint.plotX;
                    }

                    if (options.draggableY) {
                        dragPoint = hoverPoint;

                        dragY = e.changedTouches ? e.changedTouches[0].pageY : e.pageY;
                        dragPlotY = dragPoint.plotY + (chart.plotHeight - (dragPoint.yBottom || chart.plotHeight));
                    }

                    // Disable zooming when dragging
                    if (dragPoint) {
                        chart.mouseIsDown = false;
                    }
                }
            }
        };

        Highcharts.Chart.prototype.callbacks.push(function (chart) {

            var container = chart.container,
                dragPoint,
                dragX,
                dragY,
                dragPlotX,
                dragPlotY;

            chart.redraw(); // kill animation (why was this again?)

            addEvent(container, 'mousedown touchstart', function (e) {
                var hoverPoint = chart.hoverPoint,
                    options;

                if (hoverPoint) {
                    options = hoverPoint.series.options;
                    if (options.draggableX) {
                        dragPoint = hoverPoint;
                        dragX = e.originalEvent.changedTouches ? e.originalEvent.changedTouches[0].pageX : e.pageX;
                        dragPlotX = dragPoint.plotX;
                    }

                    if (options.draggableY) {
                        dragPoint = hoverPoint;

                        dragY = e.originalEvent.changedTouches ? e.originalEvent.changedTouches[0].pageY : e.pageY;
                        dragPlotY = dragPoint.plotY + (chart.plotHeight - (dragPoint.yBottom || chart.plotHeight));
                    }

                    // Disable zooming when dragging
                    if (dragPoint) {
                        chart.mouseIsDown = false;
                    }
                }
            });

            addEvent(container, 'mousemove touchmove', function (e) {
                
                e.preventDefault();

                if (dragPoint) {
                    var pageX = e.originalEvent.changedTouches ? e.originalEvent.changedTouches[0].pageX : e.pageX,
                        pageY = e.originalEvent.changedTouches ? e.originalEvent.changedTouches[0].pageY : e.pageY,
                        deltaY = dragY - pageY,
                        deltaX = dragX - pageX,
                        draggableX = dragPoint.series.options.draggableX,
                        draggableY = dragPoint.series.options.draggableY,
                        series = dragPoint.series,
                        isScatter = series.type === 'bubble' || series.type === 'scatter',
                        newPlotX = isScatter ? dragPlotX - deltaX : dragPlotX - deltaX - dragPoint.series.xAxis.minPixelPadding,
                        newPlotY = chart.plotHeight - dragPlotY + deltaY,
                        newX = dragX === undefined ? dragPoint.x : dragPoint.series.xAxis.translate(newPlotX, true),
                        newY = dragY === undefined ? dragPoint.y : dragPoint.series.yAxis.translate(newPlotY, true),
                        proceed;

                    
                    newX = filterRange(newX, series, 'X');
                    newY = filterRange(newY, series, 'Y');

                    // Fire the 'drag' event with a default action to move the point.
                    dragPoint.firePointEvent(
                        'drag', {
                        newX: draggableX ? newX : dragPoint.x,
                        newY: draggableY ? newY : dragPoint.y
                    },

                    function () {
                        proceed = true;

                        dragPoint.update({
                            x: draggableX ? newX : dragPoint.x,
                            y: draggableY ? newY : dragPoint.y
                        }, false);

                        if (chart.tooltip) {
                            chart.tooltip.refresh(chart.tooltip.shared ? [dragPoint] : dragPoint);
                        }
                        if (series.stackKey) {
                            chart.redraw();
                        } else {
                            series.redraw();
                        }
                    });

                    // The default handler has not run because of prevented default
                    if (!proceed) {
                        drop();
                    }
                }
            });

            function drop(e) {
                if (dragPoint) {
                    if (e) {
                        var pageX = e.originalEvent.changedTouches ? e.originalEvent.changedTouches[0].pageX : e.pageX,
                            pageY = e.originalEvent.changedTouches ? e.originalEvent.changedTouches[0].pageY : e.pageY,
                            draggableX = dragPoint.series.options.draggableX,
                            draggableY = dragPoint.series.options.draggableY,
                            deltaX = dragX - pageX,
                            deltaY = dragY - pageY,
                            series = dragPoint.series,
                            isScatter = series.type === 'bubble' || series.type === 'scatter',
                            newPlotX = isScatter ? dragPlotX - deltaX : dragPlotX - deltaX - dragPoint.series.xAxis.minPixelPadding,
                            newPlotY = chart.plotHeight - dragPlotY + deltaY,
                            newX = dragX === undefined ? dragPoint.x : dragPoint.series.xAxis.translate(newPlotX, true),
                            newY = dragY === undefined ? dragPoint.y : dragPoint.series.yAxis.translate(newPlotY, true);

                        newX = filterRange(newX, series, 'X');
                        newY = filterRange(newY, series, 'Y');

                        dragPoint.update({
                            x: draggableX ? newX : dragPoint.x,
                            y: draggableY ? newY : dragPoint.y
                        });
                    }
                    dragPoint.firePointEvent('drop');
                }
                dragPoint = dragX = dragY = undefined;
            }
            addEvent(document, 'mouseup touchend', drop);
            addEvent(container, 'mouseleave', drop);
        });

        /**
         * Extend the column chart tracker by visualizing the tracker object for small points
         */
        Highcharts.wrap(Highcharts.seriesTypes.column.prototype, 'drawTracker', function (proceed) {
            var series = this,
                options = series.options;
            proceed.apply(series);

            if (options.draggableX || options.draggableY) {

                each(series.points, function (point) {


                    point.graphic.attr(point.shapeArgs.height < 3 ? {
                        'stroke': 'black',
                            'stroke-width': 2,
                            'dashstyle': 'shortdot'
                    } : {
                        'stroke-width': series.options.borderWidth,
                            'dashstyle': series.options.dashStyle || 'solid'
                    });
                });
            }
        });

    })(Highcharts);
