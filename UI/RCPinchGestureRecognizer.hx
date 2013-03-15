CGFloat           _initialTouchDistance;
    CGFloat           _initialTouchScale;
    NSTimeInterval    _lastTouchTime;
    CGFloat           _velocity;
    CGFloat           _previousVelocity;
    CGFloat           _scaleThreshold;
    CGAffineTransform _transform;
    CGPoint           _anchorPoint;
    UITouch          *_touches[2];
    CGFloat           _hysteresis;
    id                _transformAnalyzer;
    unsigned int      _endsOnSingleTouch:1;
}

@property (nonatomic)          CGFloat scale;               // scale relative to the touch points in screen coordinates
@property (nonatomic,readonly) CGFloat velocity;            // velocity of the pinch in scale/second