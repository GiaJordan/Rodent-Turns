# Rodent Turns
## Video Tracking analysis for VTE movements


Software to adjust brightness and contrast of behavior task videos recorded in low light. A neural network (DeepLabCut) is used to identify body parts of each rat (Head/Neck/Tail base) to be used in further analysis. Matlab code filters the position data for each body part and calcualtes the angle of the rat's body in each frame. Body angle is used to determine periods of increase looking behavior that will be integrated into other analysis pipelines.
