/*
 * Copyright 2008-2010 Sun Microsystems, Inc.  All Rights Reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Sun designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Sun in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
 * CA 95054 USA or visit www.sun.com if you need additional information or
 * have any questions.
 */

import com.sun.btrace.BTraceUtils;
import com.sun.btrace.Profiler;
import com.sun.btrace.annotations.*;

/**
 * This script demonstrates new capabilities built into BTrace 1.2
 * <ol>
 * <li>Shortened syntax - when omitting "public" identifier in the class 
 * definition one can safely omit all other modifiers when declaring methods
 * and variables</li>
 * <li>Extended syntax for <b>@ProbeMethodName</b> annotation - you can use
 * <b>fqn</b> parameter to request a fully qualified method name instead of 
 * the short one</li>
 * <li>Profiling support - you can use {@linkplain Profiler} instance to gather
 * performance data with the smallest overhead possible
 * </ol>
 * @since 1.2
 */
@BTrace class Profiling {
    @Property
    Profiler jgitProfiler = BTraceUtils.Profiling.newProfiler();
    
//    @OnMethod(clazz="/org\\.eclipse\\.jgit\\..*/", method="/.*/")
	@OnMethod(clazz = "/org\\.eclipse\\.orion\\..*/", method = "/.*/")
    void entry(@ProbeMethodName(fqn=true) String probeMethod) { 
        BTraceUtils.Profiling.recordEntry(jgitProfiler, probeMethod);
    }
    
//    @OnMethod(clazz="/org\\.eclipse\\.jgit\\..*/", method="/.*/", location=@Location(value=Kind.RETURN))
    @OnMethod(clazz="/org\\.eclipse\\.orion\\..*/", method="/.*/", location=@Location(value=Kind.RETURN))
    void exit(@ProbeMethodName(fqn=true) String probeMethod, @Duration long duration) { 
        BTraceUtils.Profiling.recordExit(jgitProfiler, probeMethod, duration);
    }
    
    @OnEvent
    void timer() {
        BTraceUtils.Profiling.printSnapshot("JGit performance profile", jgitProfiler, "%1$s,%2$s,%3$s,%4$s,%5$s,%6$s,%7$s,%8$s,%9$s,%10$s");
        BTraceUtils.Profiling.reset(jgitProfiler);	
    }
}
