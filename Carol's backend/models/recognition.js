"use strict";

require("@tensorflow/tfjs-node");
const tf = require("@tensorflow/tfjs");
const nodeFetch = require("node-fetch");
const fapi = require("face-api.js");
const path = require("path");
const { createCanvas, createImageData } = require("canvas");
const {
  RTCVideoSink,
  RTCVideoSource,
  i420ToRgba,
  rgbaToI420
} = require("wrtc").nonstandard;

fapi.env.monkeyPatch({ fetch: nodeFetch });
const MODELS_URL = path.join(__dirname, "/weights");

const width = 640;
const height = 480;

Promise.all([
  fapi.nets.tinyFaceDetector.loadFromDisk(MODELS_URL),
  fapi.nets.faceLandmark68Net.loadFromDisk(MODELS_URL),
  fapi.nets.faceRecognitionNet.loadFromDisk(MODELS_URL),
  fapi.nets.faceExpressionNet.loadFromDisk(MODELS_URL)
]);


console.log(fapi.nets)


  async function detect(url) {
    const labeledFaceDescriptors = await loadLabeledImages()
    const faceMatcher = new fapi.FaceMatcher(labeledFaceDescriptors, 0.6)
    let image
    let canvas

    var request = require('request');
    var options = {
      url: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Hubble2005-01-barred-spiral-galaxy-NGC1300.jpg/1920px-Hubble2005-01-barred-spiral-galaxy-NGC1300.jpg",
      method: "get",
      encoding: null
    };
    request(options,async function (error, response, body) {

      if (error) {
          console.error('error:', error);
      } else {
        image = await fapi.bufferToImage(body);
        console.log("carol")
      }
    });


    // var request = require('request').defaults({ encoding: null });
    // request.get(url, async function (err, res, buffer) {
    //   image = await fapi.bufferToImage(buffer)

      // canvas = await fapi.createCanvasFromMedia(image)
      // const displaySize = { width: image.width, height: image.height }
      // fapi.matchDimensions(canvas, displaySize)

      // const detections = await fapi.detectAllFaces(image).withFaceLandmarks().withFaceDescriptors()
      // const resizedDetections = fapi.resizeResults(detections, displaySize)
      // const results = resizedDetections.map(d => faceMatcher.findBestMatch(d.descriptor))

      // results.forEach((result, i) => {
      //   const box = resizedDetections[i].detection.box
      //   const drawBox = new faceapi.draw.DrawBox(box, { label: result.toString() })
      //   drawBox.draw(canvas)
      // })

    //   var x
    //   for(var i = 0; i < results.length; i++ ){
    //     console.log(results[i].label)
    //   }
    //   console.log(results)
    // })
  }


function loadLabeledImages() {
  const labels = ['Black Widow', 'Captain America', 'Captain Marvel', 'Hawkeye', 'Jim Rhodes', 'Thor', 'Tony Stark']
    return Promise.all(
      labels.map(async label => {
        const descriptions = []
        for (let i = 1; i <= 2; i++) {
          const url = `https://raw.githubusercontent.com/WebDevSimplified/Face-Recognition-JavaScript/master/labeled_images/${label}/${i}.jpg`
          var request = require('request').defaults({ encoding: null });
          request.get(url, async function (err, res, buffer) {
            img = await fapi.bufferToImage(buffer)
            const detections = await fapi.detectSingleFace(img).withFaceLandmarks().withFaceDescriptor()
            descriptions.push(detections.descriptor)
          })
        }
        
        return new fapi.LabeledFaceDescriptors(label, descriptions)
      })
    )
  }


  module.exports = detect;