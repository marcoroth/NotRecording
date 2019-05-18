@interface CAMViewfinderViewController : UIViewController
  -(BOOL)isRecording;
  -(long long)_currentMode;
@end

static UIView *notRecordingView;
static BOOL enabled;

static UIView* createView(){
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat width = screen.size.width;
  CGFloat height = screen.size.height;
  CGRect rect = CGRectMake((width-200)/2, (height-200)/2, 200, 200);

  notRecordingView = [[UIView alloc] initWithFrame:rect];
  notRecordingView.backgroundColor = [UIColor blackColor];
  notRecordingView.layer.cornerRadius = 10.0;
  notRecordingView.alpha = 0.6;

  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 200, 40)];
  [label setTextColor:[UIColor whiteColor]];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[UIFont fontWithName: @"SF Display Pro" size: 40.0f]];
  label.text = @"You are not Recording";
  label.textAlignment = NSTextAlignmentCenter;

  UIImage *image = [UIImage imageNamed:@"/var/mobile/Documents/ch.marcoroth.notrecording/icon.png"];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 25, 100, 100)];
  imageView.image = image;

  [notRecordingView addSubview:imageView];
  [notRecordingView addSubview:label];

  return notRecordingView;
}

static void rotateView(){
  double rads;

  switch ([UIDevice currentDevice].orientation) {
    case UIDeviceOrientationLandscapeLeft:
      rads = M_PI;
      break;
    case UIDeviceOrientationLandscapeRight:
      rads = -M_PI_2 * 2;
      break;
    default:
      rads = 0;
      break;
  }

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.1];

  notRecordingView.transform = CGAffineTransformIdentity;
  notRecordingView.transform = CGAffineTransformMakeRotation((rads * (90) / 180.0));

  [UIView commitAnimations];
}

%hook CAMViewfinderViewController
  -(id)viewfinderView {
    UIView *view = %orig;

    // If mode is video and not recording
    if (enabled && [self _currentMode] == 1 && ![self isRecording]) {
      if (notRecordingView == nil) {
        createView();
      }

      rotateView();

      [view addSubview:notRecordingView];
    } else {
      [notRecordingView removeFromSuperview];
    }

    return view;
  }
%end

// Credit: github/CPDigitalDarkroom
// https://github.com/CPDigitalDarkroom/TapTapFlip/blob/master/TapTapFlip.xm#L181
static void loadPrefs() {
  CFPreferencesAppSynchronize(CFSTR("ch.marcoroth.notrecording"));
  enabled = !CFPreferencesCopyAppValue(CFSTR("isEnabled"), CFSTR("ch.marcoroth.notrecording")) ? YES : [(id)CFPreferencesCopyAppValue(CFSTR("isEnabled"), CFSTR("ch.marcoroth.notrecording")) boolValue];
}

%ctor{
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("ch.marcoroth.notrecording/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  loadPrefs();
}
