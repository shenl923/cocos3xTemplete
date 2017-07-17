effect = {}

function effect.tweenJelly(target, onEnd)
    if instanceExist(target) then
        target:stopAllActions()
        local action = cc.Sequence:create(cc.ScaleTo:create(0.1, 1.2, 0.8),
            cc.EaseSineOut:create(cc.ScaleTo:create(0.25, 0.8, 1.15)),
            cc.EaseSineIn:create(cc.ScaleTo:create(0.12, 1.1, 0.9)),
            cc.EaseSineOut:create(cc.ScaleTo:create(0.1, 1, 1)),
            cc.CallFunc:create(function() doCallback(onEnd, target) end))
        target:runAction(action)
    end
end

function effect.tweenScale(target, scaleTo, timeSpan)
    timeSpan = timeSpan or 0.12
    target:stopAllActions()
    local action = cc.EaseSineOut:create(cc.ScaleTo:create(timeSpan, scaleTo))
    target:runAction(action)
end

function effect.tweenStress(target, boundScale, timeSpan, onEnd)
    boundScale = boundScale or 0.97
    timeSpan = timeSpan or 0.1
    if target.currentScale == nil then
        target.currentScale = target:getScale()
    end
    target:runAction(cc.Sequence:create(cc.ScaleTo:create(timeSpan, boundScale),
        cc.EaseBackOut:create(cc.ScaleTo:create(timeSpan * 1.5, target.currentScale)),
        cc.CallFunc:create(function()
            doCallback(onEnd, target)
        end)))
end

function effect.tweenRepeatFade(target, alpha1, alpha2)
    alpha1 = alpha1 and toint(alpha1) or 0
    alpha2 = alpha2 and toint(alpha2) or 255
    target:stopAllActions()
    target:setOpacity(alpha1)
    local action = cc.Sequence:create(cc.FadeTo:create(0.2, alpha2),
        cc.DelayTime:create(0.1),
        cc.FadeTo:create(0.2, alpha1),
        cc.DelayTime:create(0.2))
    target:runAction(cc.RepeatForever:create(action))
end

function effect.tweenShake(target, stepX, onEnd)
    if target.__isShaking == true then return end
    stepX = stepX or 5
    local startX = target:getPositionX()
    local startY = target:getPositionY()
    local stepDelay = 0.08
    target:runAction(cc.Sequence:create(cc.MoveTo:create(stepDelay, cc.p(startX - stepX, startY)),
        cc.MoveTo:create(stepDelay, cc.p(startX + stepX, startY)),
        cc.MoveTo:create(stepDelay, cc.p(startX - stepX, startY)),
        cc.MoveTo:create(stepDelay, cc.p(startX + stepX, startY)),
        cc.MoveTo:create(stepDelay, cc.p(startX, startY)),
        cc.CallFunc:create(function()
            target.__isShaking = nil
            doCallback(onEnd)
        end)))
    target.__isShaking = true
end