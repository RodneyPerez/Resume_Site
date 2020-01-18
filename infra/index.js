'use strict';
const default_src = "default-src 'self'; "
const font_src = "font-src https://fonts.googleapis.com/ https://fonts.gstatic.com https://use.fontawesome.com; "
const style_src = "style-src https://use.fontawesome.com https://stackpath.bootstrapcdn.com https://cdn.rawgit.com/ ;"
const frame_ancestors = "frame-ancestors 'none'; " 
const csp_string = default_src + style_src + font_src + frame_ancestors  

exports.handler = async (event, context, callback) => {
    const response = event.Records[0].cf.response;
    // // const request = event.Records[0].cf.request;
    const headers = response.headers;
    //Set new headers 
    // headers['content-security-policy'] = [{key: 'Content-Security-Policy', value: csp_string}];
    headers['strict-transport-security'] = [{key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubdomains; preload'}]; 
    headers['x-content-type-options'] = [{key: 'X-Content-Type-Options', value: 'nosniff'}]; 
    headers['x-frame-options'] = [{key: 'X-Frame-Options', value: 'DENY'}]; 
    headers['x-xss-protection'] = [{key: 'X-XSS-Protection', value: '1; mode=block'}]; 
    headers['referrer-policy'] = [{key: 'Referrer-Policy', value: 'same-origin'}]; 
    callback(null, response);
};
