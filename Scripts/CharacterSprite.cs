using Godot;
using System.Threading;
using R3;
using GodotTask;

[GlobalClass]
public partial class CharacterSprite : CharacterBody2D
{
	ReactiveProperty<float> _verticalSpeed=new();
	public ReadOnlyReactiveProperty<float> VerticalSpeed=>_verticalSpeed;
	
	[Export] AnimationTree _animationTree;
	
	[Signal]
	public delegate void DamagedEventHandler();
	
	const float JumpVelocity = -500f;
	const float Gravity = 1000f;
	
	CancellationTokenSource _cts;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready(){
		VerticalSpeed
			.Select(y => y<0f ? "Rising" : "Descending")
			.DistinctUntilChanged()
			.Subscribe(state=>{
				var stateMachine=(AnimationNodeStateMachinePlayback)_animationTree.Get("parameters/playback");
				stateMachine.Travel(state);
			}).AddTo(this);
	}
	
	public override void _Process(double delta){
		var currentVelocity=Velocity;
		
		currentVelocity.Y+=Gravity*(float)delta;
		
		if(Input.IsMouseButtonPressed(MouseButton.Left)){
			currentVelocity.Y=JumpVelocity;
		}
		
		_verticalSpeed.Value=currentVelocity.Y;
		
		Velocity=currentVelocity;
		
		MoveAndSlide();
	}
	
	void OnArea2dAreaEntered(Area2D area){
		if(_cts is not null){
			return;
		}
		
		_cts=new();
		
		HitAnimation(_cts.Token);
		EmitSignal(SignalName.Damaged);
	}
	
	async GDTask HitAnimation(CancellationToken ct){
		var time = 0f;
		var defaultColor = Modulate;
		
		const float damageInterval = 1.5f;
		const float lapCounts = 15f;
		const float lapTimes = damageInterval/lapCounts;
		
		var tween = CreateTween();
		
		tween.TweenProperty(
			this,
			"modulate:a",
			0f,
			lapTimes * 0.5f
		);
		tween.TweenProperty(
			this,
			"modulate:a",
			1f,
			lapTimes * 0.5f
		);
		tween.SetLoops((int)lapCounts);
		
		await ToSignal(tween, Tween.SignalName.Finished);
		
		Modulate = defaultColor;
		
		_cts.Dispose();
		_cts=null;
	}	
	
	float TriangleWave(float x){
		float t = x % 2f;
		return t < 1f ? t : 2f - t;
	}
	
	public override void _ExitTree(){
		_cts?.Dispose();
	}
}