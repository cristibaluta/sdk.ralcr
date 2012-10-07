
/**		
 * 
 *	GKBoid v1.00
 *	15/10/2008 11:31
 * 
 *	© JUSTIN WINDLE | soulwire ltd
 *	http://blog.soulwire.co.uk
 *	
 *	Released under the Creative Commons 3.0 license
 *	@see http://creativecommons.org/licenses/by/3.0/
 *	
 *	You can modify this script in any way you choose 
 *	and use it for any purpose providing this header 
 *	remains Intact and the original author is credited
 * 
 **/

enum GKEdgeBehavior {
	NONE;
	WRAP;
	BOUNCE;
}

class GKBoid {
	
	inline public static var ZERO = new RCVector(0, 0, 0);
	
	public var extra :Dynamic;// An empty Object to store any extra data
	public var maxForce (getMaxForce, setMaxForce) :Float;
	public var maxSpeed (getMaxSpeed, setMaxSpeed) :Float;
	var _maxForce :Float;
	var _maxSpeed :Float;
	var _distance :Float;
	var _drawScale :Float;
	var _maxForceSQ :Float;
	var _maxSpeedSQ :Float;
	public var velocity : RCVector;// The current velocity of the GKBoid
	public var position : RCVector;// The position of the GKBoid in 3D space
	var _oldPosition : RCVector;
	var _acceleration : RCVector;
	var _steeringForce : RCVector;
	//var _screenCoords : RCPoint;
	public var edgeBehavior : GKEdgeBehavior;
	public var boundsRadius :Float;
	public var boundsCentre :RCVector;
	var _radius :Float;
	var _wanderTheta :Float;
	var _wanderPhi :Float;
	var _wanderPsi :Float;
	public var wanderRadius :Float;// The radius of the circle used for calculating the wander behavior of the GKBoid
	public var wanderDistance :Float;// The distance in front of the GKBoid at which the circle for calculating rotation will  be placed.
	var wanderStep :Float;
	var lookAtTarget :Bool;// If true, the GKBoid will adjust it's x, y and z rotation in order to face the direction in which it is travelling
	
#if flash
	var _matrix :flash.geom.Matrix3D;
	var _renderData :flash.display.DisplayObject;
#end

	

	/**
	 * A Point object representing the GKBoid's 
	 * x and y positions on the screen after 
	 * being projected onto a 2D surface
	 */
		 /*
	public function getScreenCoords() :RCPoint {
		calculateScreenCoords();
		return _screenCoords;
		}*/

	/**
	 * The maximum force available to the GKBoid when
	 * calculating the steering force produced by 
	 * the GKBoids steering bahaviors
	 */

	public function getMaxForce() :Float {
		return _maxForce;
	}

	public function setMaxForce( value :Float ) :Float {
		
		if (value < 0)
			value = 0;
			
		_maxForce = value;
		_maxForceSQ = value * value;
		
		return value;
	}

	/**
	 * The maximum speed the GKBoid can reach
	 */

	public function getMaxSpeed() :Float {
		return _maxSpeed;
	}

	public function setMaxSpeed( value :Float ) :Float {
		
		if (value < 0)
			value = 0;
			
		_maxSpeed = value;
		_maxSpeedSQ = value * value;

		return value;
	}

	
#if flash
	/**
	 * The DisplayObject used to render the GKBoid
	 */
	public function getRenderData() :flash.display.DisplayObject {
		return _renderData;
	}

	public function setRenderData( value :flash.display.DisplayObject ) : Void {
		
		_renderData = value;
		
		if (_renderData.width > _renderData.height) {
			_radius = _renderData.width;
		}
		else {
			_radius = _renderData.height;
		}
		
		if (_matrix == null) {
			_matrix = new flash.geom.Matrix3D();
		}
	}
#end
	
	/**
	 * How the GKBoid behaves when it reaches the
	 * boundaries of the stage. Possible values are:
	 * 
	 * EDGE_NONE
	 * 
	 * The GKBoid ignores the stage boundaries
	 * 
	 * EDGE_WRAP
	 * 
	 * If the GKBoid reaches the edge of the stage it 
	 * will switch it's position to the opposite edge
	 * 
	 * EDGE_BOUNCE
	 * 
	 * The GKBoid will bounce off the side of it's 
	 * boundaries in order to stay within them
	 */

	/**
	 * The boundaries in which the GKBoid can move.
	 * By default, these are set automatically from
	 * from the stage of the GKBoids renderData (if 
	 * one is provided). Alternatively, you can
	 * override this by specifying a new Rectangle
		 

	public function get bounds() : Object
	{
	return _bounds;
	}

	public function set bounds( value : Object ) : Void
	{
	_customBounds = true;
	_bounds = value;
	}*/
		
	/**
	 * The centrepoint of the GKBoids bounding sphere.
	 * If the GKBoid travels futher than boundsRadius 
	 * from this point the specified edge behavior 
	 * will take affect.
	 */

	/**
	 * The maximum distance which this GKBoid can 
	 * travel from it's boundsCentre before the 
	 * specified edge behavior takes affect
	 */

	

	/**
	 * The maximum angle, in radians, that the 
	 * GKBoid's wander behavior can turn at each 
	 * step. When calculating wander, a number 
	 * will be chosen at random with this as the 
	 * maximum value in each direction (either 
	 * positive or negative rotation)
	 */

	
	
	public function new ( ?maxForce:Float = 1.0, ?maxSpeed:Float=10.0, ?edgeBehavior:GKEdgeBehavior) {
		
		this.maxForce = maxForce;
		this.maxSpeed = maxSpeed;
		this.edgeBehavior = edgeBehavior == null ? NONE : edgeBehavior;
		this.wanderDistance = 60.0;
		this.boundsCentre = new RCVector();
		_radius = 10.0;
		_wanderTheta = 0.0;
		_wanderPhi = 0.0;
		_wanderPsi = 0.0;
		wanderRadius = 16.0;
		wanderStep = 0.25;
		lookAtTarget = true;
		
		reset();
	}
	
	
	/**
	 * Creates a shape and draws a triangle of a defined size 
	 * and colour to using it's graphics. This method is useful 
	 * for quickly getting up and running with a GKBoid by creating
	 * simple graphics to represent the GKBoid. You can tell the
	 * GKBoid to use this shape by setting its renderData property
	 */
#if flash
	public function createDebugShape (?colour:Int = 0x000000, ?size:Float=6, ?scale:Float=1.0) :flash.display.Shape {
		
		_drawScale = 1 / scale;
		
		var g = new flash.display.Shape();
		var s = size * scale;
		var d = s * 0.75;
		
		g.graphics.beginFill(colour);
		g.graphics.moveTo(-s, -d);
		g.graphics.lineTo(s, 0);
		g.graphics.lineTo(-s, d);
		g.graphics.lineTo(-s, -d);
		g.graphics.endFill();
		
		return g;
	}
#end
	/**
	 * After calling one or more of the GKBoid's steering methods, 
	 * call the update method in order to set the GKBoid's position 
	 * in relation to the force being applied to it as a result of 
	 * it's steering behaviors. If the GKBoid's edgeBehavior property 
	 * is anything other than EDGE_NONE (no edge behavior) then the 
	 * GKBoid's position will be modified accordingly after the 
	 * steering forces have been applied
	 */

	public function update() : Void {
		
		_oldPosition.x = position.x;
		_oldPosition.y = position.y;
		_oldPosition.z = position.z;
		
		velocity.incrementBy ( _acceleration );
		
		if (velocity.lengthSquared > _maxSpeedSQ ) {
			velocity.normalize();
			velocity.scaleBy(_maxSpeed);
		}
		
		position.incrementBy ( velocity );
		
		_acceleration.x = 0;
		_acceleration.y = 0;
		_acceleration.z = 0;
		
		if ( edgeBehavior == NONE || Math.isNaN (boundsRadius) ) return;
		
		if( !position.equals (_oldPosition) ) {
			
			var distance :Float = RCVector.distanceBetween (position, boundsCentre);
				
			if( distance > boundsRadius + _radius ) {
				switch( edgeBehavior ) {
					case BOUNCE :
						
						/**
					 	 * Move the boid to the edge of the boundary 
					 	 * then invert it's velocity and step it 
					 	 * forward back Into the sphere 
					 	 */
							
						position.decrementBy (boundsCentre);
						position.normalize();
						position.scaleBy (boundsRadius + _radius);
							
						velocity.scaleBy(-1);
						position.incrementBy (velocity);
						position.incrementBy (boundsCentre);
						
					case WRAP :
							
						/**
						 * Move the GKBoid to the antipodal point of it's 
						 * current position on the bounding sphere by 
						 * taking the inverse of it's position vector
						 */

						position.decrementBy (boundsCentre);
						position.negate();
						position.incrementBy (boundsCentre);
				}
			}
		}
	}

	/**
	 * Updates the DisplayObject used as the GKBoid's renderData 
	 * by setting the Matrix3D of it's transform property. If 
	 * lookAtTarget is set to true, the DisplayObject will also 
	 * be rotated in order to face the GKBoids velocity vector
	 */
#if flash
	public function render() : Void {
		
		if (!_renderData || !_renderData.stage || !_renderData.visible ) return;
			
		_matrix.identity();
			
		if (_drawScale != 1.0) {
			_matrix.appendScale (_drawScale, _drawScale, _drawScale);
		}
			
		if (lookAtTarget) {
			_matrix.pointAt (velocity, RCVector.X_AXIS, RCVector.Y_AXIS);
		}
			
		_matrix.appendTranslation (position.x, position.y, position.z);
			
		_renderData.transform.matrix3D = _matrix;
	}
#end
	/**
	 * Constrains the GKBoid to a rectangular area of the screen 
	 * by calculating the 2D position of the GKBoid on the screen, 
	 * limiting it to the dimensions of the Rectangle and then 
	 * projecting the resulting values back Into 3D space
	 * 
	 * @param	rect
	 * 
	 * The rectangle to constrain the GKBoid's position to
	 * 
	 * @param	behavior
	 * 
	 * Since this method is a substitute for the normal 
	 * edge behavior, you can specify which behavior the 
	 * GKBoid should use manually
	 * 
	 * @param	zMin
	 * 
	 * Use this if you wish to constrain the GKBoid's z 
	 * position to a minimum amount
	 * 
	 * @param	zMax
	 * 
	 * Use this if you wish to constrain the GKBoid's z 
	 * position to a maximum amount
	 * 
	 */
	
	public function constrainToRect (rect:RCRect, ?behavior:GKEdgeBehavior=BOUNCE, ?zMin:Null<Float>, ?zMax:Null<Float>) :Void {
		
		if ( !_renderData || !_renderData.stage || !_renderData.visible ) return;
			
		calculateScreenCoords();
			
		if (_screenCoords.x < rect.left - _radius) {
			switch( behavior ) {
				case NONE:null;
				case WRAP :
					
					_screenCoords.x = rect.right;
					_renderData.transform.matrix3D.identity();
					position.x = _renderData.globalToLocal3D(_screenCoords).x;
					
				case BOUNCE :
					
					position.x = rect.left;
					velocity.x *= -1;
					
					break;
			}
		}
		else if ( _screenCoords.x > rect.right + _radius ) {
			switch( behavior ) {
				case NONE:null;
				case WRAP :
					
					_screenCoords.x = rect.left;
					_renderData.transform.matrix3D.identity();
					position.x = _renderData.globalToLocal3D(_screenCoords).x;
					
				case BOUNCE :
					
					position.x = rect.right;
					velocity.x *= -1;
			}
		}
			
		if ( _screenCoords.y < rect.top - _radius ) {
			switch( behavior ) {
				case NONE:null;
				case WRAP :
					
					_screenCoords.y = rect.bottom;
					_renderData.transform.matrix3D.identity();
					position.y = _renderData.globalToLocal3D(_screenCoords).y;
					
				case BOUNCE :
					
					position.y = rect.top;
					velocity.y *= -1;
			}
		}
		else if ( _screenCoords.y > rect.bottom + _radius ) {
			switch( behavior ) {
				case NONE:null;
				case WRAP :
					
					_screenCoords.y = rect.top;
					_renderData.transform.matrix3D.identity();
					position.y = _renderData.globalToLocal3D(_screenCoords).y;
					
				case BOUNCE :
					
					position.y = rect.bottom;
					velocity.y *= -1;
			}
		}
			
		if (Math.isNaN(zMin) || Math.isNaN(zMax)) return;
			
		if ( position.z < zMin - _radius ) {
			switch( behavior ) {
				case NONE:null;
				case WRAP :
					
					position.z = zMax;
					
				case BOUNCE :
					
					position.z = zMin;
					velocity.z *= -1;
			}
		}
		else if ( position.z > zMax + _radius ) {
			switch( behavior ) {
				case NONE:null;
				case WRAP :
					
					position.z = zMin;
					
				case BOUNCE :
					
					position.z = zMax;
					velocity.z *= -1;
			}
		}
	}

	// BEHAVIORS
		
	/**
	 * Applies a braking force to the boid by scaling it's velocity.
	 * 
	 * @param	brakingForce - A number between 0 and 1. 0 = no effect
	 */

	public function brake (?brakingForce :Float = 0.01) :Void {
		velocity.scaleBy (1 - brakingForce);
	}

	/**
	 * Seeks the GKBoid towards the specified target
	 * 
	 * @param	target
	 * 
	 * The target for the GKBoid to seek
	 * 
	 * @param	multiplier
	 * 
	 * By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function seek (target :RCVector, ?multiplier :Float = 1.0) :Void {
		
		_steeringForce = steer ( target );
		
		if (multiplier != 1.0) {
			_steeringForce.scaleBy ( multiplier );
		}
		
		_acceleration.incrementBy ( _steeringForce );
	}
	
	/**
	 * Seeks the GKBoid towards the specified target and 
	 * applies a deceleration force as the GKBoid arrives
	 * 
	 * @param	target
	 * 
	 * The target for the GKBoid to seek
	 * 
	 * @param	easeDistance
	 * 
	 * The distance from the target at which the GKBoid should 
	 * begin to decelerate
	 * 
	 * @param	multiplier
	 * 
	 * By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function arrive (target:RCVector, easeDistance:Float = 100, multiplier:Float=1.0) :Void {
		
		_steeringForce = steer (target, true, easeDistance);
			
		if ( multiplier != 1.0 ) {
			_steeringForce.scaleBy ( multiplier );
		}
			
		_acceleration.incrementBy ( _steeringForce );
	}

	/**
	 * If a target is within a certain range of the GKBoid, as 
	 * specified by the panicDistance parameter, the GKBoid will 
	 * steer to aVoid contact with the target
	 * 
	 * @param	target
	 * 
	 * The target for the GKBoid to aVoid
	 * 
	 * @param	panicDistance
	 * 
	 * If the distance between the GKBoid and the target position 
	 * is greater than this value, the GKBoid will ignore the 
	 * target and it's steering force will be unchanged
	 * 
	 * @param	multiplier
	 * 
	 * By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function flee ( target : RCVector, ?panicDistance :Float = 100, ?multiplier :Float = 1.0 ) : Void {
		
		_distance = RCVector.distanceBetween (position, target);
			
		if ( _distance > panicDistance ) return;
			
		_steeringForce = steer (target, true, -panicDistance);
			
		if ( multiplier != 1.0 ) {
			_steeringForce.scaleBy ( multiplier );
		}
			
		_steeringForce.negate();
		_acceleration.incrementBy ( _steeringForce );
	}

	/**
	 * Generates a random wandering force for the GKBoid. 
	 * The results of this method can be controlled by the 
	 * wanderDistance, wanderStep and wanderRadius parameters
	 * 
	 * @param	multiplier
	 * 
	 * By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function wander (?multiplier:Float = 1.0) : Void {
		
		_wanderTheta += -wanderStep + Math.random() * wanderStep * 2;
		_wanderPhi += -wanderStep + Math.random() * wanderStep * 2;
		_wanderPsi += -wanderStep + Math.random() * wanderStep * 2;
			
		if ( Math.random() < 0.5 ) {
			_wanderTheta = -_wanderTheta;
		}
			
		var pos = velocity.clone();
			pos.normalize();
			pos.scaleBy ( wanderDistance );
			pos.incrementBy ( position );
			
		var offset : RCVector = new RCVector();
			offset.x = wanderRadius * Math.cos(_wanderTheta);
			offset.y = wanderRadius * Math.sin(_wanderPhi);
			offset.z = wanderRadius * Math.cos(_wanderPsi);
			
		_steeringForce = steer ( pos.add ( offset));
			
		if ( multiplier != 1.0 ) {
			_steeringForce.scaleBy ( multiplier );
		}
			
		_acceleration.incrementBy ( _steeringForce );
	}

	/**
	 * Use this method to simulate flocking movement in a 
	 * group of GKBoids. Flock will combine the separate, 
	 * align and cohesion steering behaviors to produce 
	 * the flocking effect. Adjusting the weighting of each 
	 * behavior, as well as the distance values for each 
	 * can produce distinctly different flocking behaviors
	 * 
	 * @param	boids - An Array of GKBoids to consider when calculating the flocking behavior
	 * @param	separationWeight - The weighting given to the separation behavior
	 * @param	alignmentWeight - The weighting given to the alignment bahavior
	 * @param	cohesionWeight - The weighting given to the cohesion bahavior
	 * @param	separationDistance - The distance which each GKBoid will attempt to maintain
	 * between itself and any other GKBoid in the flock
	 * @param	alignmentDistance - If another GKBoid is within this distance, this GKBoid will 
	 * consider the other GKBoid's heading when adjusting it's own
	 * @param	cohesionDistance - If another GKBoid is within this distance, this GKBoid will 
	 * consider the other GKBoid's position when adjusting it's own
	 * @param	multiplier - By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function flock ( boids:Array<GKBoid>,
							?separationWeight :Float = 0.5, 
							?alignmentWeight :Float = 0.1, 
							?cohesionWeight :Float = 0.2, 
							?separationDistance :Float = 100.0, 
							?alignmentDistance :Float = 200.0, 
							?cohesionDistance :Float = 200.0) :Void
	{
		separate (boids, separationDistance, separationWeight);
		align (boids, alignmentDistance, alignmentWeight);
		cohesion (boids, cohesionDistance, cohesionWeight);
	}

	/**
	 * Separation will attempt to ensure that a certain distance 
	 * is maintained between any given GKBoid and others in the flock
	 * 
	 * @param	boids
	 * 
	 * An Array of GKBoids to consider when calculating the behavior
	 * 
	 * @param	separationDistance
	 * 
	 * The distance which the GKBoid will attempt to maintain between 
	 * itself and any other GKBoid in the flock
	 * 
	 * @param	multiplier
	 * 
	 * By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function separate (boids :Array<GKBoid>, ?separationDistance :Float = 50.0, ?multiplier :Float = 1.0) :Void {
		
		_steeringForce = getSeparation (boids, separationDistance);
			
		if ( multiplier != 1.0 ) {
			_steeringForce.scaleBy ( multiplier );
		}
			
		_acceleration.incrementBy ( _steeringForce );
	}

	/**
	 * Align will correct the GKBoids heading in order for it 
	 * to point in the average direction of the flock
	 * 
	 * @param	boids
	 * 
	 * An Array of GKBoids to consider when calculating the behavior
	 * 
	 * @param	neighborDistance
	 * 
	 * If another GKBoid is within this distance, this GKBoid will 
	 * consider the other GKBoid's heading when adjusting it's own
	 * 
	 * @param	multiplier
	 * 
	 * By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function align (boids :Array<GKBoid>, neighborDistance :Float = 40.0, multiplier :Float = 1.0) :Void {
		
		_steeringForce = getAlignment (boids, neighborDistance);
			
		if ( multiplier != 1.0 ) {
			_steeringForce.scaleBy ( multiplier );
		}
			
		_acceleration.incrementBy ( _steeringForce );
	}

	/**
	 * Cohesion will attempt to make all GKBoids in the flock converge 
	 * on a point which lies at the centre of the flock
	 * 
	 * @param	boids
	 * 
	 * An Array of GKBoids to consider when calculating the behavior
	 * 
	 * @param	neighborDistance
	 * 
	 * If another GKBoid is within this distance, this GKBoid will 
	 * consider the other GKBoid's position when adjusting it's own
	 * 
	 * @param	multiplier
	 * 
	 * By multiplying the force generated by this behavior, 
	 * more or less weight can be given to this behavior in
	 * comparison to other behaviors being calculated by the 
	 * GKBoid. To increase the weighting of this behavior, use 
	 * a number above 1.0, or to decrease it use a number 
	 * below 1.0
	 */

	public function cohesion (boids :Array<GKBoid>, neighborDistance :Float = 10.0, multiplier :Float = 1.0) :Void {
		
		_steeringForce = getCohesion(boids, neighborDistance);
			
		if ( multiplier != 1.0 ) {
			_steeringForce.scaleBy ( multiplier );
		}
			
		_acceleration.incrementBy ( _steeringForce );
	}
	
	
	public function avoid () :Void {
		
	}
	
	public function followPath () :Void {
		
	}
	
	
	
	
	/**
	 * Resets the GKBoid's position, velocity, acceleration and 
	 * current steering force to zero
	 */

	public function reset() : Void {
		
		velocity = new RCVector();
		position = new RCVector();
		_oldPosition = new RCVector();
		_acceleration = new RCVector();
		_steeringForce = new RCVector();
		//_screenCoords = new Point();
	}
	
	//———————————————————————————————————————————————————————————

	function steer (target:RCVector, ?ease:Bool=false, ?easeDistance:Float=100) : RCVector {
		
		_steeringForce = target.clone();
		_steeringForce.decrementBy ( position );
		_distance = _steeringForce.normalize();
		
		if (_distance > 0.00001 ) {
			if (_distance < easeDistance && ease) {
				_steeringForce.scaleBy (_maxSpeed * ( _distance / easeDistance ));
			}
			else {
				_steeringForce.scaleBy ( _maxSpeed );
			}
			
			_steeringForce.decrementBy ( velocity );
			
			if (_steeringForce.lengthSquared > _maxForceSQ) {
				_steeringForce.normalize();
				_steeringForce.scaleBy ( _maxForce );
			}
		}
			
		return _steeringForce;
	}

	function getSeparation ( boids :Array<GKBoid>, ?separation :Float = 25.0 ) : RCVector {
		
		var force = new RCVector();
		var difference : RCVector;
		var distance :Float;
		var count = 0;
		var boid :GKBoid;
		
		for (i in 0...boids.length) {
			
			boid = boids[i];
			distance = RCVector.distanceBetween (position, boid.position);
			
			if (distance > 0 && distance < separation ) {
				difference = position.subtract ( boid.position );
				difference.normalize();
				difference.scaleBy (1 / distance);
				force.incrementBy ( difference );
				count++;
			}
		}
		
		if ( count > 0 ) {
			force.scaleBy (1 / count);
		}
		
		return force;
	}

	function getAlignment ( boids :Array<GKBoid>, ?neighborDistance :Float = 50.0 ) :RCVector {
		
		var force = new RCVector();
		var distance :Float;
		var count = 0;
		var boid :GKBoid;
			
		for (i in 0...boids.length) {
			boid = boids[i];
			distance = RCVector.distanceBetween (position, boid.position);
				
			if (distance > 0 && distance < neighborDistance) {
				force.incrementBy ( boid.velocity );
				count++;
			}
		}
			
		if ( count > 0 ) {
			force.scaleBy (1 / count);
				
			if (force.lengthSquared > _maxForceSQ) {
				force.normalize();
				force.scaleBy ( _maxForce );
			}
		}
			
		return force;
	}
	
	function getCohesion (boids:Array<GKBoid>, ?neighborDistance:Float=50.0) :RCVector {
		
		var force = new RCVector();
		var distance :Float;
		var count = 0;
		var boid :GKBoid;
		
		for (i in 0...boids.length) {
			boid = boids[i];
			distance = RCVector.distanceBetween (position, boid.position);
			
			if (distance > 0 && distance < neighborDistance) {
				force.incrementBy ( boid.position );
				count++;
			}
		}
		
		if (count > 0) {
			force.scaleBy (1 / count);
			force = steer ( force );
			
			return force;
		}
		
		return force;
	}

	/*function calculateScreenCoords() : Void {
		
		if (!position.equals ( _oldPosition )) {
			_screenCoords = _renderData.local3DToGlobal( ZERO );
		}
		}*/
}
